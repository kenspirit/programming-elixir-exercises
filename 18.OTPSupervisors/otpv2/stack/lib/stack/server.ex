defmodule Stack.Server do
  use GenServer

  #####
  # External API

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def push(val) do
    GenServer.cast(__MODULE__, { :push, val })
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  #####
  # GenServer implementation

  def init(_) do
    { :ok, Stack.Stash.get() }
  end

  def handle_call(:pop, _from, current_stack) do
    [ head | tail ] = current_stack
    { :reply, head, tail }
  end

  def handle_cast({ :push, val }, current_stack) do
    { :noreply, [ val | current_stack ] }
  end

  def terminate(reason, state) do
    IO.puts "State to be persisted: #{inspect state}"
    Stack.Stash.update(state)
  end
end
