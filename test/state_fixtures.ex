defmodule QsmTest.StateA do
  @behaviour Qsm.State

  def get_next_state(message) do
    {QsmTest.StateB, "m2"}
  end
end

defmodule QsmTest.StateB do
  @behaviour Qsm.State

  def get_next_state(message) do
    IO.inspect message
  end
end
