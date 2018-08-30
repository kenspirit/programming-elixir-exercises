defmodule Sequence.Stash do
  use GenServer

  # External API
  def start_link(init_number) do
    GenServer.start_link(__MODULE__, init_number, name: __MODULE__)
  end

  def update(val) do
    GenServer.cast(__MODULE__, { :update, val })
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  # GenServer Implementation
  def init(init_number) do
    { :ok, init_number }
  end

  def handle_cast({ :update, val }, _current_number) do
    { :noreply, val }
  end

  def handle_call(:get, _from, current_number) do
    { :reply, current_number, current_number }
  end
end
