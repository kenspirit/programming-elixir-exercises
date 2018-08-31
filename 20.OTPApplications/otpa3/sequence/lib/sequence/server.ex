defmodule Sequence.Server do
  use GenServer

  @vsn "1"

  defmodule State do
    defstruct(current_number: 0, delta: 1)
  end

  # External API
  def start_link(init_number) do
    GenServer.start_link(__MODULE__, init_number, name: __MODULE__)
  end

  def increment_number(delta) do
    GenServer.cast(__MODULE__, { :increment_number, delta })
  end

  def next_number() do
    with number = GenServer.call(__MODULE__, :next_number),
    do: "The next number is #{number}"
  end

  # GenServer Implementation
  def init(_) do
    state = %State{
      current_number: Sequence.Stash.get(:current_number),
      delta: Sequence.Stash.get(:delta)
    }
    { :ok, state }
  end

  def handle_cast({ :increment_number, delta }, state) do
    { :noreply, %{ state | delta: delta } }
  end

  def handle_call(:next_number, _from, state = %{ current_number: n }) do
    { :reply, n, %{ state | current_number: n + state.delta } }
  end

  def terminate(_reason, state) do
    IO.puts "State to be persisted: #{inspect state}"
    Sequence.Stash.update(:current_number, state.current_number)
    Sequence.Stash.update(:delta, state.delta)
  end

  def code_change("0", old_state = current_number, _extra) do
    new_state = %State{
      current_number: current_number,
      delta: 1
    }
    IO.puts inspect old_state
    IO.puts inspect new_state
    { :ok, new_state }
  end
end
