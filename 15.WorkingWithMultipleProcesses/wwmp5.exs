defmodule Spawn do
  def child_exit(parent_pid) do
    send parent_pid, "Hello, there?"
    exit(:gone)
  end

  def child_exception(parent_pid) do
    send parent_pid, "Hello, there?"
    raise("Bad thing happened")
  end

  def run_with_exit() do
    spawn_monitor(Spawn, :child_exit, [self()])

    # Unlike exercise-3, even if not sleeping, seems always receive child sent msg
    # Not receiving the :DOWN msg
    # :timer.sleep(500)

    receive do
      msg ->
        IO.puts inspect msg
    end
  end

  def run_with_exception() do
    spawn_monitor(Spawn, :child_exception, [self()])

    # If sleep, always print exception msg and then received msg from child
    # If not sleep, exception msg will not be shown
    # :timer.sleep(500)

    receive do
      msg ->
        IO.puts msg
    end
  end
end

# Spawn.run_with_exit()
Spawn.run_with_exception()
