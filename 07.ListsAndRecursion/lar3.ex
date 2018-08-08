defmodule MyList do
  def map([], _func) do
    []
  end
  def map([ head | tail ], func) do
    [func.(head) | map(tail, func)]
  end
  defp encode(source, n) when source + n > ?z do
    # space \s is the first character in ASCII
    source + n - ?z + (?\s) - 1
  end
  defp encode(source, n) do
    source + n
  end
  def caesar(list, n) do
    map(list, &(encode(&1, n)))
  end
end

IO.puts(MyList.caesar('!ryvkvez', 12))
