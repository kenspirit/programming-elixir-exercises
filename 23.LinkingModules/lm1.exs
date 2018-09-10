defmodule Tracer do
  def dump_args(args) do
    args |> Enum.map(&inspect/1) |> Enum.join(", ")
  end

  def dump_defn(name, args) do
    "#{name}(#{dump_args(args)})"
  end

  defmacro def(definition = { name, _, args }, do: content) do
    quote do
      Kernel.def(unquote(definition)) do
        IO.puts "==> call: #{Tracer.dump_defn(unquote(name), unquote(args))}"
        result = unquote(content)
        IO.puts "<== result: #{result}"
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

# The IO.puts are actually executed when the defined function is called.
# the value of the result is also calculated after executing the unquoted content statements.
# Hence, the result in second interpolation does not need to use unquote.  
# The name and args must be unquote to get actual value first so that dump_defn can take during execution.
