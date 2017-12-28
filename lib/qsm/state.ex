defmodule Qsm.State do
  @callback get_next_state(Map) :: State
end
