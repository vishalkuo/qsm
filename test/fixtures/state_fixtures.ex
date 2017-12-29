defmodule Qsm.Fixtures do
  defmodule StateA do
    @behaviour Qsm.State
  
    def get_next_state(message) do
      {QsmTest.StateB, message}
    end
  end
  
  defmodule StateB do
    @behaviour Qsm.State
  
    def get_next_state(message) do
      IO.inspect message
    end
  end
end
