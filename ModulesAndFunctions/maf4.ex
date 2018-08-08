defmodule Recursion do
  def sum(0), do: 0
  def sum(n), do: n + sum(n - 1)
end

IO.puts Recursion.sum(5)
