defmodule OpentelemetryCommanded.Util do
  @moduledoc false

  def safe_context_propagation(trace_ctx) when is_nil(trace_ctx) do
    nil
  end

  def safe_context_propagation(trace_ctx) do
    trace_ctx
    |> decode_headers()
    |> :otel_propagator_text_map.extract()
  end

  def encode_headers(headers), do: Enum.map(headers, &Tuple.to_list/1)

  def decode_headers(headers), do: Enum.map(headers, &List.to_tuple/1)

  def encode_ctx(:undefined), do: :undefined
  def encode_ctx(ctx), do: Tuple.to_list(ctx)

  def decode_ctx("undefined"), do: :undefined
  def decode_ctx(:undefined), do: :undefined

  def decode_ctx(ctx) do
    Enum.map(ctx, fn
      el when is_binary(el) -> String.to_existing_atom(el)
      el -> el
    end)
    |> List.to_tuple()
  end

  def struct_name(name) when is_binary(name), do: String.replace(name, ~r/^Elixir\./, "")
  def struct_name(%name{}), do: inspect(name)
  def struct_name(name), do: inspect(name)

  def messaging_attributes(context, kind, handler) do
    [
      "messaging.conversation_id": context.correlation_id,
      "messaging.destination": struct_name(handler),
      "messaging.destination_kind": kind,
      "messaging.message_id": context.causation_id,
      "messaging.operation": "receive",
      "messaging.system": "commanded"
    ]
  end

  def event_attributes(event) do
    [
      "commanded.causation_id": event.causation_id,
      "commanded.correlation_id": event.correlation_id,
      "commanded.event": struct_name(event.event_type),
      "commanded.event_id": event.event_id,
      "commanded.event_number": event.event_number,
      "commanded.stream_id": event.stream_id,
      "commanded.stream_version": event.stream_version
    ]
  end
end
