defmodule Qsm.SqsManagerTest do
  use ExUnit.Case, async: false
  doctest Qsm
  Code.load_file("../fixtures/state_fixtures.ex", __DIR__)
  
  import Mock


  setup do
    {:ok, queue_name: "test_queue"} 
  end

  test "sends message correctly", state do
    expected_q_msg = %Qsm.QueueMessage{
      module_name: Qsm.Fixtures.StateA,
      body: "my_data"
    }
    expected_ser_message = Poison.encode!(expected_q_msg)
    with_mock ExAws,
      [request: fn 
        %{action: :send_message} -> :ok
      end] do
        Qsm.SqsManager.send_message(
          state[:queue_name], 
          expected_q_msg.module_name, 
          expected_q_msg.body)

        assert called ExAws.request(
          %{action: :send_message,
            path: "/" <> state[:queue_name],
            params: %{"MessageBody" => expected_ser_message}})
      end
  end

  test "extracts transition" do 
    message = "arbitrary message"
    q_msg = %Qsm.QueueMessage{
      module_name: Qsm.Fixtures.StateA,
      body: message
    }
    ser_msg = Poison.encode!(q_msg)
    expected_resp = Qsm.Fixtures.StateA.get_next_state(message)

    res = Qsm.SqsManager.get_transition(ser_msg)

    assert(res == expected_resp)
  end
end
