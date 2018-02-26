defmodule Qsm do
  use Agent
  alias Qsm.SqsManager

  @moduledoc """
  Documentation for Qsm.
  """

  @type queue_name :: String.t()

  @type state_data :: map()

  @spec enqueue_work(queue_name, Qsm.State, state_data) :: nil
  def initialize_entry(queue_name, entry_state, entry_data \\ nil) do
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

  @spec run(PID) :: none
  def run(pid) do
    Agent.get(pid, fn m ->
      m[:pollers]
      |> Enum.each(fn p ->
        Task.start(fn ->
          EPoller.poll(p)
        end)
      end)

      :ok
    end)
  end
end
