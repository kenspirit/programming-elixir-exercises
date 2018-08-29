defmodule Stack.Server do
  use GenServer

  def init(init_stack) do
    { :ok, init_stack }
  end

  def handle_call(:pop, _from, current_stack) do
    [ head | tail ] = current_stack
    { :reply, head, tail }
  end
end
