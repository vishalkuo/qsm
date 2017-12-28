defmodule Qsm.QueueMessage do
  @derive [Poison.Encoder]
  defstruct [:module_name, :body]
end
