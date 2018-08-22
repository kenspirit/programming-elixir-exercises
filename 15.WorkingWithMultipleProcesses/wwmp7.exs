defmodule Parallel do
  def pmap(collection, fun) do
    me = self()

    collection
    |> Enum.map(fn (elem) ->
      spawn_link fn -> (
        # Add sleep function to create random scenario
        :timer.sleep(Enum.random(10..1000))
        send me, { self(), fun.(elem) }
      ) end
    end)
    |> Enum.map(fn (_) ->
      receive do { _pid, result } -> result end
    end)
  end
end

IO.puts inspect Parallel.pmap(1..10, &(&1 * &1))
