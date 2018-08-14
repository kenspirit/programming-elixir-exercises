# form: number [+-*/] number

# calculate('123 + 27') # = > 150

defmodule SAB do
  defp cal(left_op, op, right_op) do
    l_op = List.to_integer(Enum.reverse(left_op))
    r_op = List.to_integer(right_op)

    cond do
      op === ?+ -> l_op + r_op
      op === ?- -> l_op - r_op
      op === ?* -> l_op * r_op
      op === ?/ -> l_op / r_op
      true -> IO.puts "Invalid operator #{op}"
    end
  end

  defp parse([ head | tail ], right_op) do
    cond do
      head === ?\s -> parse(tail, right_op)
      head in [?+, ?-, ?*, ?/] -> cal(List.delete_at(tail, 0), head, right_op)
      true -> parse(tail, [ head | right_op])
    end
  end
  def calculate(formula) do
    # Solution 1: Assuming there is exactly one space around the operator
    [ right_op | remained ] = Enum.reverse(formula)
    parse(remained, [ right_op ])
  end

  defp parse2([ head | tail ], op, left_op, is_ready) do
    cond do
      head === ?\s -> parse2(tail, op, left_op, is_ready)
      head in [?+, ?-, ?*, ?/] -> parse2(tail, head, left_op, true)
      is_ready -> cal(left_op, op, [ head | tail ])
      true -> parse2(tail, op, [ head | left_op ], is_ready)
    end
  end
  def calculate2(formula) do
    # Solution 2: No any assumption on how many spaces around operator
    parse2(formula, ' ', [], false)
  end
end

IO.puts SAB.calculate2('123 + 27')
