defmodule Qsm.QsmTest do
  use ExUnit.Case
  doctest Qsm

  setup do
    {:ok, queue_name: "test_queue"}
  end

  test "enqueues message without data", state do
    res = Qsm.enqueue_work(state[:queue_name], Qsm.MockEntryState)
    assert res == :ok
  end

  test "enqueues message with data", state do
    res = Qsm.enqueue_work(state[:queue_name], Qsm.MockEntryState, "foo")
    assert res == :ok
  end

  test "starts link appropriately", state do
    num_pollers = 5
    {:ok, pid} = Qsm.start_link(state[:queue_name], num_pollers)

    Agent.get(pid, fn m ->
      assert state[:queue_name] == m[:queue_name]
      assert num_pollers == length(m[:pollers])

      m[:pollers]
      |> Enum.each(fn p ->
        Agent.get(p, fn poller ->
          assert state[:queue_name] == poller[:queue_name]
        end)
      end)
    end)
  end
end
