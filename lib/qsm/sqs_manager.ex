defmodule Qsm.SqsManager do

  def get_transition(message) do
    data = Poison.decode!(message, as: %Qsm.QueueMessage{})
    
    data.module_name
      |> String.to_atom
      |> apply(:get_next_state, [data.body])
  end


  def message_handler(message) do 
    {module_name, body} = get_transition(message)
    if module_name do
      to_send = create_message(module_name, body)
      ExAws.SQS.send_message("my_worker_queue", to_send)  
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

  def do_stuff() do
    EPoller.start_link("my_worker_queue", &message_handler(&1))
  end
end
