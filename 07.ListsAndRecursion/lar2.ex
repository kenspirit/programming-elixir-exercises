defmodule Recursion do
  def max([]) do
    nil
  end
  def max([ head | [] ]) do
    head
  end
  def max([ head | [ subhead | [] ] ]) when head > subhead do
    head
  end
  def max([ head | [ subhead | [] ] ]) when subhead > head do
    subhead
  end
  def max([ head | [ subhead | subtail ] ]) when head > subhead do
    max([ head | subtail ])
  end
  def max([ head | [ subhead | subtail ] ]) when subhead > head do
    max([ subhead | subtail ])
  end
end

IO.puts(Recursion.max([0, 56, 12, 32]))
