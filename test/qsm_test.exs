defmodule QsmTest do
  use ExUnit.Case, async: false
  doctest Qsm

  import Mock

  test "start" do
    {:ok, uut} = Qsm.SqsManager.do_stuff()
    
  end
end
