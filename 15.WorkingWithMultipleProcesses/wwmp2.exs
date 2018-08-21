defmodule Spawn do
  def echo(pid) do
    receive do
      message ->
        send pid, message
    end
  end

  defp spawn_process(token) do
    pid = spawn(Spawn, :echo, [self()])
    
    send pid, token

    receive do
      msg ->
        IO.puts "Received on #{Time.utc_now()} for: #{msg}"
    end
  end

  def echo_tokens([ token1, token2 ]) do
    spawn_process(token1)
    spawn_process(token2)
  end
end

Spawn.echo_tokens(["Ken", "Winnie"])
