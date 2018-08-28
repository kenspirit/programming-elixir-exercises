defmodule Ticker do
  @interval 2000 # 2 seconds
  @name     :ticker

  def start do
    { :ok, agent } = Agent.start_link(fn -> [] end)

    IO.puts "Agent: #{inspect agent}"

    status = :global.register_name(@name, agent)

    process(status, agent)
  end

  defp process(:no, agent) do
    # global agent is already registered
    Agent.stop(agent)

    agent = :global.whereis_name(@name)

    IO.puts "Agent retrieve: #{inspect agent}"

    register_client(agent)
  end

  defp process(:yes, agent) do
    # global agent created and registered
    IO.puts "Agent registered"
    register_client(agent)
  end

  defp register_client(agent) do
    me = self()

    IO.puts "Registering client #{inspect me}"

    client_num = Agent.get_and_update(agent, fn clients -> { length(clients), clients ++ [ me ] } end)

    if client_num == 0 do
      # First client
      send me, { :tick }
    end

    tick(agent, me)
  end

  def tick(agent, pid) do
    receive do
      { :tick } ->
        clients = Agent.get(agent, fn c -> c end)

        idx = Enum.find_index(clients, fn p -> p == pid end)
        IO.puts "tock in client No.#{idx + 1}"

        # Wait and notify_next next client
        :timer.sleep(@interval)

        notify_next(clients, idx + 1)

        # Wait for next notification
        tick(agent, pid)
      after @interval ->
        # Kept waiting
        IO.puts "Kept waiting notification"
        tick(agent, pid)
    end
  end

  defp notify_next(clients, idx) when idx == 0 or idx >= length(clients) do
    # Reach to the end, send msg to first client
    IO.puts "Notifying client 1"
    send Enum.at(clients, 0), { :tick }
  end

  defp notify_next(clients, idx) do
    # Reach to next client
    IO.puts "Notifying client #{idx + 1}"
    send Enum.at(clients, idx), { :tick }
  end
end

# A ring of clients. A client sends a tick to the next client in the ring. 
# After 2 seconds, that client sends a tick to its next client.

# Solution A:
# 1. Try to register glocal name for an agent of list of clients
# 2. If success, this is the first client;  If failed, get the registered one and join in list
# 3. If it's the first client, send :tick msg to itself.  Else, keeps waiting until previous client's notification
# 4. When a client echoes, it waits two seconds to find's the next client to notify

# For these two questions:
# 1. When thinking about how to add clients to the ring, remember to deal with the case where a client’s receive loop times out just as you’re adding a new process.
#    A new client can be added any time as it's the responsibility of the client in the upper chain to notify the next.
# 2. What does this say about who has to be responsible for updating the links?
#    The client itself is responsible for updating the links.

# The problem here is that if one process dies, the remained clients in ring will all keep waiting finally as the dead client has not removed itself from the list.
