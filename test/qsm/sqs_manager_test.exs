defmodule Qsm.SqsManagerTest do
  use ExUnit.Case, async: false
  doctest Qsm
  Code.load_file("../fixtures/state_fixtures.ex", __DIR__)

  import Mock

  setup do
    {:ok, queue_name: "test_queue"}
  end

  test "sends message correctly", state do
  end

  test "extracts transition" do
  end

  test "handles message with next state", state do
  end

  test "handles message without next state", state do
  end
end
