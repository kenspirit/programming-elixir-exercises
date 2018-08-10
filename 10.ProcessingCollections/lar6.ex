defmodule MyList do
  defp innerFlatten([], result) do
    result
  end
  defp innerFlatten([ head | tail ], result) do
    if not is_list(head) do
      innerFlatten(tail, result ++ [ head ])
    else
      innerFlatten(head ++ tail, result)
    end
  end
  def flatten([]) do
    []
  end
  def flatten(list) do
    innerFlatten(list, [])
  end
end

IO.puts(inspect(MyList.flatten([1, [2, 3, 4], 5, [[[6]]]])))
