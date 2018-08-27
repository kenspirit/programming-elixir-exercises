defmodule Ticker do
  @internal 2000 # 2 seconds
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([ pid | clients ])
      after @internal ->
        IO.puts "tick"
        Enum.each clients, fn client ->
          send client, { :tick }
        end

        generator(clients)
    end
    
  end
end

# Because the tick is implemented as timeout of receiving msg, if there are clients kept registering, then timeout in the receive loop will never be reached.
# Then the ticker will not be exactly 2 seconds interval.
