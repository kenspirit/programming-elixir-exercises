defmodule MyList do
  defp spanList(cur, to, list) when cur === to do
    [ cur | list ]
  end
  defp spanList(cur, to, list) do
    spanList(cur, to - 1, [ to | list ])
  end
  def span(from, to) when is_integer(from) and is_integer(to) and from <= to do
    spanList(from, to, [])
  end
  def span(from, to) do
    IO.puts "#{from} and #{to} must be integer and satisfy #{from} <= #{to}"
  end
end

IO.puts(inspect(MyList.span(10, 21)))
