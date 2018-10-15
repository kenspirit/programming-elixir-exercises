defmodule OwnEnumerable do
  def each(map, fun) do
    Enum.reduce(map, nil, fn item, _ ->
      fun.(item)
      nil
    end)
  end

  def filter(list, fun) do
    Enum.reduce(list, [], fn item, acc ->
      if fun.(item) do
        [item | acc]
      else
        acc
      end
    end)
  end

  def map(list, fun) do
    Enum.reduce(list, [], fn item, acc ->
      [fun.(item) | acc]
    end)
  end
end

OwnEnumerable.each(%{a: [1], b: [2]}, fn v ->
  IO.puts inspect v
end)

OwnEnumerable.filter(%{a: [1], b: [2]}, fn { key, _value } ->
  key == :a
end)

OwnEnumerable.map(%{a: [1], b: [2]}, fn { key, value } ->
  { key, [ 6 | value ] }
end)
