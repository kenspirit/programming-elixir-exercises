defprotocol Caesar do
  def encrypt(string, shift)
  def rot13(string)
end

defimpl Caesar, for: BitString do
  defp encode(source, n) when source + n > ?z do
    # space \s is the first character in ASCII
    source + n - ?z + (?\s) - 1
  end

  defp encode(source, n) do
    source + n
  end

  def encrypt(string, shift) do
    Enum.map(String.to_charlist(string), &(encode(&1, shift)))
    |> to_string()
  end

  def rot13(string) do
    encrypt(string, 13)
  end
end


defimpl Caesar, for: List do
  defp encode(source, n) when source + n > ?z do
    # space \s is the first character in ASCII
    source + n - ?z + (?\s) - 1
  end

  defp encode(source, n) do
    source + n
  end

  defp convert(val) when is_number(val) do
    [val]
  end

  defp convert(val) when is_list(val) do
    val
  end

  defp convert(val) when is_bitstring(val) do
    String.to_charlist(val)
  end

  defp convert(val) do
    String.to_charlist(to_string(val))
  end

  def encrypt(list, shift) do
    Enum.reduce(list, [], &(&2 ++ convert(&1)))
    |> Enum.map(&(encode(&1, shift)))
    |> to_string()
  end

  def rot13(list) do
    encrypt(list, 13)
  end
end


IO.puts Caesar.rot13("!ryvkvez")
IO.puts Caesar.rot13('!ryvkvez')
IO.puts Caesar.rot13([20, 'ry', "ry"])
IO.puts Caesar.encrypt([120, 'ry', "ry", :atom], 5)
