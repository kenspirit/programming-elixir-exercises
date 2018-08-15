defmodule SAB do
  def capitalize_sentences(sentence) do
    parts = String.split(sentence, ". ")
    parts = Enum.map(parts, &(String.capitalize(&1)))
    Enum.reduce(parts, fn p, acc -> acc <> ". " <> p  end)
  end
end

IO.puts SAB.capitalize_sentences("oh. a DOG. woof.")
