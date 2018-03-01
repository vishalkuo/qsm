defmodule Qsm.MockExAws do
  defmodule SQS do
    def send_message(_queue_name, _message) do
      :ok
    end
  end

  def request(_r) do
    :ok
  end
end
