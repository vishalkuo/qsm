defmodule Qsm.SqsManager do

  def get_transition(message) do
    data = Poison.decode!(message, as: %Qsm.QueueMessage{})
    
    data.module_name
      |> String.to_atom
      |> apply(:get_next_state, [data.body])
  end


  def message_handler(queue_name, message) do 
    case get_transition(message) do
      {module_name, body} -> send_message(queue_name, module_name, body)
      _ -> nil
    end
  end

  defp create_message(module_name, body) do
    message = %Qsm.QueueMessage{
      module_name: module_name,
      body: body}
    Poison.encode!(message)
  end

  def send_message(queue_name, state, data) do
    message = create_message(state, data)
    ExAws.SQS.send_message(queue_name, message) 
      |> ExAws.request
  end
end
