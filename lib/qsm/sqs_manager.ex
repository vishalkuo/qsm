defmodule Qsm.SqsManager do
  @aws Application.get_env(:qsm, :aws)

  @spec message_handler(Qsm.queue_name(), String.t()) :: :ok
  def message_handler(queue_name, message) do
    case apply_transition(message) do
      {module_name, body} -> send_message(queue_name, module_name, body)
      _ -> :ok
    end
  end

  defp apply_transition(message) do
    data = Poison.decode!(message, as: %Qsm.QueueMessage{})

    data.module_name
    |> String.to_atom()
    |> apply(:get_next_state, [data.body])
  end

  defp create_message(module_name, body) do
    message = %Qsm.QueueMessage{module_name: module_name, body: body}
    Poison.encode!(message)
  end

  @spec send_message(Qsm.queue_name(), Qsm.State, Qsm.state_data()) :: :ok
  def send_message(queue_name, state, data) do
    message = create_message(state, data)

    @aws.SQS.send_message(queue_name, message)
    |> @aws.request()

    :ok
  end
end
