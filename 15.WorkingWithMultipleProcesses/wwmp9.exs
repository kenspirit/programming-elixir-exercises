# Uncomment this code to dynamically generate testing files
# animals = ["cat", "dog", "fish", "chicken", "cow", "mouse", "monkey"]
# len = length(animals) - 1

# Enum.each(1..20000, fn n ->
#   times = Enum.random(0..1000)
#   content = Enum.reduce(0..times, "", fn _, acc ->
#     acc <> Enum.at(animals, Enum.random(0..len)) <> " "
#   end)

#   File.write("./fixtures/#{n}.txt", content)
# end)

defmodule FileCatCounter do 
  def count(scheduler) do
    send scheduler, { :ready, self() }

    receive do
      { :client, file, client } ->
        send client, { :answer, file, _count(file), self() }
        count(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end

  defp _count(file) do
    cnt = File.read!(file)
    |> String.split("cat")
    |> length

    cnt - 1
  end
end

defmodule Scheduler do
  def run(num_processes, module, func, process_items) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self()]) end)
    |> schedule_processes(process_items, [])
  end

  def schedule_processes(processes, process_item_queue, results) do
    receive do
      { :ready, pid } when length(process_item_queue) > 0 ->
        [ next | tail ] = process_item_queue
        send pid, { :client, next, self() }
        schedule_processes(processes, tail, results)

      { :ready, pid } ->
        send pid, { :shutdown }
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), process_item_queue, results)
        else
          Enum.sort(results, fn { n1, _ }, { n2, _ } -> n1 <= n2 end)
        end

      { :answer, item, result, _pid} ->
        schedule_processes(processes, process_item_queue, [ { item, result } | results ])
    end
  end
end

files = File.ls!("./fixtures/")
  |> Enum.map(&("./fixtures/#{&1}"))

Enum.each 1..10, fn num_processes ->
  { time, result } = :timer.tc(Scheduler, :run, [ num_processes, FileCatCounter, :count, files ])

  if num_processes == 1 do
    IO.puts inspect result
    IO.puts "\n #   time (s)"
  end

  :io.format "~2B   ~.2f~n", [ num_processes, time / 1000000.0 ]
end
