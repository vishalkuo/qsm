defmodule Qsm.MockExAws do
  defmodule SQS do
    def send_message(queue_name, message) do 
      :ok
    end
  end

  def request(r) do
    :ok
  end
end