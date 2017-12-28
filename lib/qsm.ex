defmodule Qsm do
  use Agent
  alias Qsm.SqsManager

  @moduledoc """
  Documentation for Qsm.
  """

  @type queue_name :: String.t

  @type state_data :: map()

  @spec initialize_entry(queue_name, Qsm.State, state_data // nil) :: {:ok, PID}
  def initialize_entry(queue_name, entry_state, entry_data) do
    Qsm.SqsManager.send_message(queue_name, entry_state, entry_data)
    start_link(queue_name)
  end

  @spec start_link(queue_name) :: {:ok, PID}
  def start_link(queue_name) do
    # Agent.start_link(fn -> %{:queue_name -> queue_name} end)
    nil
  end

  @spec run(PID) :: none
  def run(pid) do
    # SqsManager.initialize()
    nil
  end

  
end
