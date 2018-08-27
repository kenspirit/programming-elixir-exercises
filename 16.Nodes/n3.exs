defmodule Ticker do
  @internal 2000 # 2 seconds
  @name     :ticker

  def start do
    { :ok, agent } = Agent.start_link(fn -> 1 end)

    pid = spawn(__MODULE__, :generator, [agent, []])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(agent, clients) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator(agent, clients ++ [ pid ])
      after @internal ->
        n = Agent.get(agent, fn n -> n end)

        handle(agent, clients, n)
    end
  end

  defp handle(agent, clients, _) when length(clients) == 0 do
    IO.puts "There is no client registered"
    generator(agent, clients)
  end

  defp handle(agent, clients, n) when n > length(clients) do
    IO.puts "Last client has been notified, back to first one"
    handle(agent, clients, 1)
  end

  defp handle(agent, clients, n) do
    IO.puts "tick to client No.#{n}"
    client = Enum.at(clients, n - 1)
    send client, { :tick, n }

    Agent.update(agent, fn _ -> n + 1 end)

    generator(agent, clients)
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick, n } ->
        IO.puts "tock in client No.#{n}"
        receiver()
    end
  end
end
