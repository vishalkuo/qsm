defmodule Qsm.TestEntryState do
  @behaviour Qsm.State

  def get_next_state(m) do
    Process.sleep(1000)
    {Qsm.TestExitState, %{"Hello" => "world"}}
  end
end

defmodule Qsm.TestExitState do
  @behaviour Qsm.State

  def get_next_state(m) do
    IO.inspect(m)
    Process.sleep(1000)
    nil
  end
end
