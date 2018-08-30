defmodule Sequence.Server do
  use GenServer

  @vsn "0"

  # External API
  def start_link(init_number) do
    GenServer.start_link(__MODULE__, init_number, name: __MODULE__)
  end

  def update(val) do
    GenServer.cast(__MODULE__, { :update, val })
  end

  def next_number() do
    with number = GenServer.call(__MODULE__, :get),
    do: "The next number is #{number}"
  end

  # GenServer Implementation
  def init(_) do
    { :ok, Sequence.Stash.get() }
  end

  def handle_cast({ :update, val }, _current_number) do
    { :noreply, val }
  end

  def handle_call(:get, _from, current_number) do
    { :reply, current_number, current_number + 1 }
  end

  def terminate(_reason, state) do
    IO.puts "State to be persisted: #{inspect state}"
    Sequence.Stash.update(state)
  end
end
