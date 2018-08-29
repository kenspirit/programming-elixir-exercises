defmodule Stack.Server do
  use GenServer

  #####
  # External API

  def start_link(init_stack) do
    GenServer.start_link(__MODULE__, init_stack, name: __MODULE__)
  end

  def push(val) do
    GenServer.cast(__MODULE__, { :push, val })
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  #####
  # GenServer implementation

  def init(init_stack) do
    { :ok, init_stack }
  end

  def handle_call(:pop, _from, current_stack) do
    [ head | tail ] = current_stack
    { :reply, head, tail }
  end

  def handle_cast({ :push, val }, current_stack) do
    { :noreply, [ val | current_stack ] }
  end

  def terminate(reason, _) do
    IO.puts inspect reason
  end
end
