defmodule SAB do
  defp convert(data) do
    # Solution 1
    parts = String.split(data, ",")
    { id, _ } = Integer.parse(Enum.at(parts, 0))
    ship_to = String.to_atom(String.replace_prefix(Enum.at(parts, 1), ":", ""))
    { amount, _ } = Float.parse(Enum.at(parts, 2))
    
    # Solution 2
    # Have a beter way to do binary pattern match & conversion?
    # << id::bits-size(24), ",:", ship_to::bits-size(16), ",", amount::binary >> = data
    # { id, _ } = Integer.parse(id)
    # ship_to = String.to_atom(ship_to)
    # { amount, _ } = Float.parse(amount)

    [ id: id, ship_to: ship_to, net_amount: amount ]
  end
  def parseCSV(data) do
    data = String.replace_trailing(data, "\n", "")

    cond do
      String.equivalent?(data, "id,ship_to,net_amount") -> []
      true -> [convert(data)]
    end
  end
  def sales_tax(orders) do
    tax_rates = [ NC: 0.075, TX: 0.08 ]

    for order <- orders, do: order ++ [ total_amount: order[:net_amount] * (1 + (tax_rates[order[:ship_to]] || 0)) ]
  end
end

Stream.resource(
  fn -> File.open!("./sab7-fixtures.csv") end,
  fn file ->
    case IO.read(file, :line) do data when
      is_binary(data) -> {SAB.parseCSV(data), file}
      _ -> {:halt, file}
    end
  end,
  fn file -> File.close(file) end
)
  |> Enum.to_list
  |> SAB.sales_tax
  |> inspect
  |> IO.puts
