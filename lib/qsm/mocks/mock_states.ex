defmodule Qsm.MockEntryState do
  @behaviour Qsm.State

  def get_next_state(m) do
    {Qsm.MockExitState, m}
  end
end

defmodule Qsm.MockExitState do
  @behaviour Qsm.State

  def get_next_state(_m) do
    nil
  end
end
