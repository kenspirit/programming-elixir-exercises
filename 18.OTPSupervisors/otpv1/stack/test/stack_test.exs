defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  test "greets the world" do
    assert Stack.hello() == :world
  end
end
