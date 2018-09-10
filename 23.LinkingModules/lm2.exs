defmodule Tracer do
  def dump_args(args) do
    args |> Enum.map(&inspect/1) |> Enum.join(", ")
  end

  def dump_defn(name, args) do
    "#{name}(#{dump_args(args)})"
  end

  defmacro def(definition = { name, _, args }, do: content) do
    import IO.ANSI
    quote do
      Kernel.def(unquote(definition)) do
        IO.puts ["==> call: ", cyan(), "#{Tracer.dump_defn(unquote(name), unquote(args))}", default_color()]
        result = unquote(content)
        IO.puts ["<== result:", red(), " #{result}", default_color()]
        result
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2]
      import unquote(__MODULE__), only: [def: 2]
    end
  end
end

defmodule Test do
  use Tracer

  def put_sum_three(a, b, c), do: IO.inspect(a+b+c)
  def add_list(list),         do: Enum.reduce(list, 0, &(&1 + &2))
end

Test.put_sum_three(1, 2, 3)
Test.add_list([5, 6, 7, 8])

# String is actually a list of char and IO.puts are taking chars list as parameters.
