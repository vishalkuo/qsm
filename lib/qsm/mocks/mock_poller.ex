defmodule Qsm.MockPoller do
  def start_link(_queue_name, _handler) do
    nil
  end

  def poll(_pid) do
    nil
  end
end
