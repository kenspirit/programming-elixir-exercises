defmodule Stack.Stash do
  use GenServer

  #####
  # External API

  def start_link(init_stack) do
    GenServer.start_link(__MODULE__, init_stack, name: __MODULE__)
  end

  def update(val) do
    GenServer.cast(__MODULE__, { :update, val })
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  #####
  # GenServer implementation

  def init(init_stack) do
    { :ok, init_stack }
  end

  def handle_call(:get, _from, current_stack) do
    { :reply, current_stack, current_stack }
  end

  def handle_cast({ :update, new_stack }, current_stack) do
    { :noreply, new_stack }
  end

  def terminate(reason, _) do
    IO.puts inspect reason
  end
end
