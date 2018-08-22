defmodule Spawn do
  def child(parent_pid) do
    send parent_pid, "Hello, there?"
    raise("Bad thing happened")
  end

  def run() do
    spawn_link(Spawn, :child, [self()])

    # Does not matter if main process sleep or not.
    # Exception always thrown and break
    # :timer.sleep(500)

    receive do
      msg ->
        IO.puts msg
    end
  end
end

Spawn.run()
