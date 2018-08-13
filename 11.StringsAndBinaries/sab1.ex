defmodule SAB do
  def printable?([ code_point | [] ]) do
    code_point < ?\~ && code_point > ?\s
  end
end

non_printable = '\0'
printable = 'A'

IO.puts "#{non_printable} is #{SAB.printable?(non_printable)}"
IO.puts "#{printable} is #{SAB.printable?(printable)}"
