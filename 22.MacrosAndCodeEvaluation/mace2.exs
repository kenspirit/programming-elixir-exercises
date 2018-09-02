defmodule Times do
  defmacro times_n(n) do
    quote do
      def unquote(:"times_#{n}")(v) do
        unquote(n) * v
      end
    end
  end
end

defmodule Test do
  require Times

  Times.times_n(3)
  Times.times_n(4)
end

IO.puts Test.times_3(4)   #=> 12
IO.puts Test.times_4(5)   #=> 20
