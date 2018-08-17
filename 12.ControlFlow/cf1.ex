defmodule FizzBuzz do
  defp fizzbuzz(n) do
    case { rem(n, 5), rem(n, 3) } do
      { 0, 0 } -> "FizzBuzz"
      { _, 0 } -> "Fizz"
      { 0, _ } -> "Buzz"
      _ -> n
    end
  end
  def upto(n) when n > 0 do
    Enum.map(1..n, &(fizzbuzz/1))
  end
end

IO.puts inspect FizzBuzz.upto(20)
