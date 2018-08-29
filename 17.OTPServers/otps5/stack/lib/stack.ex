defmodule Stack do
  @server Stack.Server

  def start_link(init_stack) do
    GenServer.start_link(@server, init_stack, name: @server)
  end

  def push(val) do
    GenServer.cast(@server, { :push, val })
  end

  def pop() do
    GenServer.call(@server, :pop)
  end
end
