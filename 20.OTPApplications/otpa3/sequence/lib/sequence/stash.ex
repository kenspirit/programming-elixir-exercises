defmodule Sequence.Stash do
  use GenServer

  # External API
  def start_link(init_data) do
    GenServer.start_link(__MODULE__, init_data, name: __MODULE__)
  end

  def update(key, val) do
    GenServer.cast(__MODULE__, { :update, key, val })
  end

  def get(key) do
    GenServer.call(__MODULE__, { :get, key })
  end

  # GenServer Implementation
  def init(init_data) do
    { :ok, init_data }
  end

  def handle_cast({ :update, key, val }, current_data) do
    { :noreply, Map.update(current_data, key, val, fn _ -> val end) }
  end

  def handle_call({ :get, key }, _from, current_data) do
    { :reply, Map.get(current_data, key), current_data }
  end
end
