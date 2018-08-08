defmodule MyList do
  def reduce([], value, _func) do
    value
  end
  def reduce([ head | tail ], value, func) do 
    reduce(tail, func.(head, value), func)
  end
  def map([], _func) do
    []
  end
  def map([ head | tail ], func) do
    [func.(head) | map(tail, func)]
  end
  def mapsum(list, func) do
    reduce(map(list, func), 0, &(&1+&2))
  end
end

IO.puts(MyList.mapsum([0, 12, 56], &(&1 * 2)))
