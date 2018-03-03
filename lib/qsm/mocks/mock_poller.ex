defmodule Qsm.MockPoller do
  def start_link(queue_name, handler) do
    Agent.start_link(fn -> %{queue_name: queue_name, handler: handler} end)
  end

  def poll(_pid) do
    nil
  end
end
