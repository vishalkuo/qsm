defmodule Qsm.Fixtures do
  defmodule StateA do
    @behaviour Qsm.State

    def get_next_state(message) do
      {Qsm.Fixtures.StateB, message}
    end
  end

  defmodule StateB do
    @behaviour Qsm.State

    def get_next_state(_) do
      nil
    end
  end
end
