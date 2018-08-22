defmodule Spawn do
  def echo(pid) do
    # Simulate process different running time scenario
    :timer.sleep(Enum.random(10..1000))
    receive do
      message ->
        send pid, message
    end
  end

  defp spawn_process(token) do
    pid = spawn(Spawn, :echo, [self()])
    
    send pid, token
  end

  def echo_tokens(tokens) do
    Enum.each(tokens, &spawn_process/1)

    # If want to ensure token1 must be received before token 2,
    # we can move below receive block into the spawn_process method
    Enum.each(tokens, fn _ ->
      receive do
        msg ->
          IO.puts "Received on #{Time.utc_now()} for: #{msg}"
      end
    end)
  end
end

Spawn.echo_tokens(["Ken", "Winnie"])
