defmodule Qsm do
  use Agent
  alias Qsm.SqsManager
  alias Qsm.PollerManager

  @moduledoc """
  Documentation for Qsm.
  """

  @type queue_name :: String.t()

  @type state_data :: map()

  @spec enqueue_work(queue_name, Qsm.State, state_data) :: nil
  def enqueue_work(queue_name, entry_state, entry_data \\ nil) do
    Qsm.SqsManager.send_message(queue_name, entry_state, entry_data)
    :ok
  end

  @spec start_link(queue_name, integer) :: {:ok, PID}
  def start_link(queue_name, num_pollers \\ 1) do
    pollers =
      1..num_pollers
      |> Enum.map(fn _x ->
        {:ok, pid} =
          EPoller.start_link(queue_name, fn m ->
            SqsManager.message_handler(queue_name, m)
          end)

        pid
      end)

    Agent.start_link(fn ->
      %{:queue_name => queue_name, :pollers => pollers}
    end)
  end

  @spec run_async(PID) :: none
  def run_async(pid) do
    Agent.get(pid, fn m ->
      m[:pollers]
      |> Enum.each(fn p ->
        spawn(fn -> 
          PollerManager.poll_infinitely(p)
        end)
      end)

      :ok
    end)
  end
end
