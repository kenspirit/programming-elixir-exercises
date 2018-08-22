defmodule Spawn do
  def child(parent_pid) do
    send parent_pid, "Hello, there?"
    exit(:gone)
  end

  def run() do
    spawn_link(Spawn, :child, [self()])

    # If main process does not sleep,
    # sometimes the msg can be received and print before exiting
    # :timer.sleep(500)

    receive do
      msg ->
        IO.puts msg
    end
  end
end

Spawn.run()
