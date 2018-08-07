defmodule Chop do
  defp match(actual, min, max) when actual === min or actual === max do
    IO.puts actual
  end
  defp match(actual, min, max) when actual > min and actual <= (div(max + min, 2)) do
    IO.puts "Is it #{(div(max + min, 2))}?"
    match(actual, min + 1, div(max + min, 2))
  end
  defp match(actual, min, max) when actual > div(max + min, 2) and actual < max do
    IO.puts "Is it #{div(max + min, 2)}?"
    match(actual, div(max + min, 2) + 1, max - 1)
  end
  def guess(actual, _) when not is_integer(actual) do
    IO.puts "Guess value #{actual} is not integer"
  end
  def guess(actual, min..max) when actual < min or actual > max do
    IO.puts "Guess value #{actual} is out of the range #{min}..#{max}"
  end
  def guess(actual, min..max) do
    match(actual, min, max)
  end
end

Chop.guess(512, 1..1000)
