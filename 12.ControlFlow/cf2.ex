defmodule FizzBuzzCond do
  def upto(n) when n > 0 do
    1..n |> Enum.map(&fizzbuzz/1)
  end

  defp fizzbuzz(n) do
    cond do
      rem(n, 3) === 0 and rem(n, 5) === 0 -> "FizzBuzz"
      rem(n, 3) === 0 -> "Fizz"
      rem(n, 5) === 0 -> "Buzz"
      true -> n
    end
  end
end

defmodule FizzBuzzCase do
  def upto(n) when n > 0 do
    Enum.map(1..n, &(fizzbuzz/1))
  end

  defp fizzbuzz(n) do
    case { rem(n, 5), rem(n, 3) } do
      { 0, 0 } -> "FizzBuzz"
      { _, 0 } -> "Fizz"
      { 0, _ } -> "Buzz"
      _ -> n
    end
  end
end

defmodule FizzBuzzGuard do
  def upto(n) when n > 0 do
    1..n |> Enum.map(&fizzbuzz/1)
  end

  defp fizzbuzz(n) do
    _fizzword(n, rem(n, 3), rem(n, 5))
  end

  defp _fizzword(_n, 0, 0), do: "FizzBuzz"
  defp _fizzword(_n, 0, _), do: "Fizz"
  defp _fizzword(_n, _, 0), do: "Buzz"
  defp _fizzword(n, _, _), do: n
end
