defmodule Qsm.PollerManager do
  @spec poll_infinitely(PID) :: nil
  def poll_infinitely(poller_pid) do 
    EPoller.poll(poller_pid)
    poll_infinitely(poller_pid)
  end
end