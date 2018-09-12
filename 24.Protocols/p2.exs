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
    Enum.map(String.to_charlist(String.trim(string)), &(encode(&1, shift)))
    |> to_string()
  end

  def rot13(string) do
    encrypt(string, 13)
  end
end

defmodule Test do
  defp read_eng_file() do
    File.stream!("./fixtures/american-words.95")
  end

  defp read_chinese_file() do
    File.read!("./fixtures/top_chinese_chars_3500.txt")
    |> String.trim()
    |> String.codepoints()
  end

  defp check(word_map) do
    keys = Map.keys(word_map)
    values = Map.values(word_map)
    common = MapSet.intersection(MapSet.new(values), MapSet.new(keys))
    IO.puts "#{MapSet.size(common)} words found after running Caesar transformation."
    common
  end

  def check_caesar_words do
    # read_eng_file()
    read_chinese_file()
    |> Stream.map(fn word ->
        { word, Caesar.rot13(word) }
      end)
    |> Enum.into(%{})
    |> check
    |> inspect
    |> IO.puts
  end
end

Test.check_caesar_words()
