defmodule SAB do
  defp pad(str, max_len) do
    len = String.length(str)
    gap = div(max_len - len, 2)

    String.pad_trailing(String.pad_leading(str, gap + len), max_len)
  end
  def center(strings) do
    max_len = String.length Enum.max_by(strings, &String.length/1)

    Enum.each(strings, &(IO.puts pad(&1, max_len)))
  end
end

SAB.center(["cat", "zebra", "elephant"])
