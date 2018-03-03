defmodule Qsm do
  use Agent
  alias Qsm.SqsManager
  alias Qsm.PollerManager

  @moduledoc """
  This module provides functionality for state machine interaction such as entry 
  points and transitions
  """

  @type queue_name :: String.t()
  @type state_data :: any

  @doc ~S"""
  Enqueue a work state on an SQS queue. This function should typically be 
  used to create an entry point into your state machine. 

  ## Examples
      iex> Qsm.enqueue_work("my_worker_queue", Qsm.MockEntryState, "test_data")
      :ok
  """
  @spec enqueue_work(queue_name, Qsm.State, state_data) :: :ok
  def enqueue_work(queue_name, entry_state, entry_data \\ nil) do
    Qsm.SqsManager.send_message(queue_name, entry_state, entry_data)
    :ok
  end

  @doc ~S"""
  Initializes the qsm process that will eventually handle state polling and
  transitions. 

  ## Examples
      iex> {:ok, pid} = Qsm.start_link("test_queue", 1)
      iex> is_pid(pid)
      true
  """
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

  @doc ~S"""
  Asynchronously polls and handles state tranistions using the number of 
  pollers when initializing the process. 

  ## Examples
      iex> {:ok, pid} = Qsm.start_link("test_queue", 1)
      iex> Qsm.run_async(pid)
      :ok
  """
  @spec run_async(PID) :: :ok
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
