defmodule QsmTest do
  use ExUnit.Case
  doctest Qsm

  test "greets the world" do
    assert Qsm.hello() == :world
  end
end
