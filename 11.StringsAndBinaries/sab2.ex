defmodule SAB do
  defp acc_count(x, acc) do
    { _v, m } = Map.get_and_update(acc, x, &({ &1, (if &1 === nil, do: 1, else: &1 + 1) }))
    m
  end
  def char_count(word) do
    Enum.reduce(word, Map.new, fn x, acc -> acc_count(x, acc) end)
  end
  def anagram?(word1, word2) do
    count1 = Map.delete(char_count(word1), ?\s)
    count2 = Map.delete(char_count(word2), ?\s)

    Map.equal?(count1, count2)
  end
end

word1 = 'anagram'
word2 = 'nag a ram'

IO.puts "#{word1} and #{word2} are anagram? #{SAB.anagram?(word1, word2)}"
