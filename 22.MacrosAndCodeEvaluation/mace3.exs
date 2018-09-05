defmodule CodeUtil do
  @operators %{ :+ => "add", :- => "minus", :* => "multiply", :/ => "divided by" }

  defmacro explain(expressions) do
    expression = Keyword.get(expressions, :do, nil)

    # IO.puts "================"
    # IO.puts inspect expression
    IO.puts explain_op(expression)
  end

  defp build_sentence(op, left_op, right_op) do
    case op do
      :/ -> "#{left_op} #{Map.get(@operators, op)} #{right_op}"
      :- -> "#{left_op} #{Map.get(@operators, op)} #{right_op}"
      _ -> "#{Map.get(@operators, op)} #{left_op} and #{right_op}"
    end
  end

  defp explain_op({op, _, [left_op, right_op]})
  when is_number(left_op) and is_number(right_op) do
    build_sentence(op, left_op, right_op)
  end

  defp explain_op({op, _, [left_op, right_op]})
  when not is_number(left_op) and not is_number(right_op) do
    explain_op(left_op) <> ", then #{Map.get(@operators, op)} the result of " <> explain_op(right_op)
  end

  defp explain_op({op, _, [left_op, right_op]})
  when not is_number(right_op) do
    case op do
      :/ -> "#{left_op} #{Map.get(@operators, op)} the result of #{explain_op(right_op)}"
      _ -> explain_op(right_op) <> ", then #{Map.get(@operators, op)} #{left_op}"
    end
  end

  defp explain_op({op, _, [left_op, right_op]})
  when not is_number(left_op) do
    explain_op(left_op) <> ", then #{Map.get(@operators, op)} #{right_op}"
  end
end

defmodule Test do
  import CodeUtil

  explain do: 2 + 3 #= > add 2 and 3
  explain do: (2 + 3) * (4 - 1) #=> add 2 and 3, then multiply the result of 4 minus 1
  explain do: 2 + 3 * 4 #= > multiply 3 and 4, then add 2
  explain do: 2 + 3 * (4 / 2) #= > 4 divided by 2, then multiply 3, then add 2
  explain do: 2 * 3 - 4 / 2 #= > multiply 2 and 3, then minus the result of 4 divided by 2
end
