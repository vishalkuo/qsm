defmodule Qsm.SqsManagerTest do
  use ExUnit.Case
  doctest Qsm
  Code.load_file("../fixtures/state_fixtures.ex", __DIR__)

  setup do
    {:ok, queue_name: "test_queue"}
  end

  test "sends message correctly", state do
    res = Qsm.SqsManager.send_message(state[:queue_name], Qsm.MockEntryState, "foo")
    assert res == :ok
  end

  test "handles message with next state", state do
    message = Poison.encode!(%Qsm.QueueMessage{module_name: Qsm.MockEntryState, body: "foo"})
    res = Qsm.SqsManager.message_handler(state[:queue_name], message)
    assert res == :ok
  end

  test "handles message without next state", state do
    message = Poison.encode!(%Qsm.QueueMessage{module_name: Qsm.MockExitState, body: "foo"})
    res = Qsm.SqsManager.message_handler(state[:queue_name], message)
    assert res == nil
  end
end
