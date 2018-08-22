```elixir
defmodule Parallel do
  def pmap(collection, fun) do
    me = self()

    collection
    |> Enum.map(fn (elem) ->
      spawn_link fn -> (send me, { self(), fun.(elem) }) end
    end)
    |> Enum.map(fn (pid) ->
      receive do { ^pid, result } -> result end
    end)
  end
end
```

Use `me = self()` at the top is to obtain the pid of the parent process for spawned child processes to send back msg.  
If not using this and calling self() in the spawn_link function code, it's actually getting the child process pid.  
