defmodule MyEnum do
  def all?([], _func) do
    true
  end
  def all?([ head | tail ], func) do
    func.(head) and all?(tail, func)
  end

  def each([], _func) do
  end
  def each([ head | tail ], func) do
    func.(head)
    each(tail, func)
  end

  def reduce([], value, _func) do
    value
  end
  def reduce([ head | tail ], value, func) do 
    reduce(tail, func.(head, value), func)
  end

  def reverse([]) do
    []
  end
  def reverse([ head | tail ]) do
    reduce(tail, [ head ], &([ &1 | &2 ]))
  end

  defp innerFilter(value, list, func) do
    if func.(value) do
      [ value | list ]
    else
      list
    end
  end
  def filter([], _func) do
    []
  end
  def filter(list, func) do
    reverse(reduce(list, [], &(innerFilter(&1, &2, func))))
  end

  def count([]) do
    0
  end
  def count([ _head | tail ]) do
    1 + count(tail)
  end

  defp innerSplit([ head | tail ], cnt, idx, first_part) do
    if (idx === cnt) do
      { first_part, [ head | tail ] }
    else
      innerSplit(tail, cnt, idx + 1, [ head | first_part ])
    end
  end
  def split(list, 0) do
    { [], list }
  end
  def split([], _cnt) do
    { [], [] }
  end
  def split(list, cnt) when cnt >= 0 do
    { first_part, second_part } = innerSplit(list, cnt, 0, [])
    { reverse(first_part), second_part }
  end
  def split(list, cnt) when cnt < 0 do
    list_count = count(list)
    pos = list_count + cnt

    if pos <= 0 do
      split(list, 0)
    else
      split(list, pos)
    end
  end

  def take(list, cnt) do
    { first_part, second_part } = split(list, cnt)
    if cnt >= 0 do
      first_part
    else
      second_part
    end
  end
end

IO.puts MyEnum.all?([1, 2, 3], &(&1 > 2))

MyEnum.each([1, 2, 3], &(IO.puts &1 * 2))

IO.puts(inspect(MyEnum.filter([1, 2, 3], &(&1 > 1))))

IO.puts(inspect(MyEnum.split([1, 2, 3, 4, 5], 2)))

IO.puts(inspect(MyEnum.split([1, 2, 3, 4, 5], -2)))

IO.puts(inspect(MyEnum.split([1, 2, 3, 4, 5], -6)))

IO.puts(inspect(MyEnum.take([1, 2, 3, 4, 5], 2)))

IO.puts(inspect(MyEnum.take([1, 2, 3, 4, 5], -2)))

IO.puts(inspect(MyEnum.take([1, 2, 3, 4, 5], -6)))
