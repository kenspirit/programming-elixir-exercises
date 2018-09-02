defmodule MyMacro do
  defmacro unless(condition, clauses) do
    do_clauses = Keyword.get(clauses, :do, nil)

    quote do
      if unquote(condition) do
        unquote(do_clauses)
      end
    end
  end
end

defmodule Test do
  require MyMacro

  MyMacro.unless 1 == 1, do: IO.puts 1 + 1
end
