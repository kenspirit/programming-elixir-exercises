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

  defp mod_zero?(dividend, divisor) do
    Integer.mod(dividend, divisor) === 0
  end
  defp found_divisible?(_dividend, divisor, max) when divisor > max do
    false
  end
  defp found_divisible?(dividend, divisor, max) do
    if mod_zero?(dividend, divisor) do
      true
    else
      found_divisible?(dividend, divisor + 1, max)
    end
  end
  def is_prime?(n) do
    half = div(n, 2)
    found_divisible?(n, 2, half)
  end
end

IO.puts inspect for n <- MyList.span(2, 200), !MyList.is_prime?(n), do: n
