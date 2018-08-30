defmodule Noaa.TableFormatter do
  defp output_sep_line do
    IO.puts "----------------------"
  end

  def print_table(location_data, columns) do
    Enum.each(location_data, fn { location, data } ->
      format_data({ location, data }, columns)
    end)
  end

  defp format_data({ location, :error }, _) do
    output_sep_line()
    IO.puts "#{location}: Error fetching from Noaa"
  end

  defp format_data({ location, body }, columns) do
    output_sep_line()
    IO.puts "Weather of #{location} from NOAA"

    { _, label } = Enum.max_by(columns, fn { _, label } ->
      String.length(label)
    end)
    max_width = String.length(label)

    Enum.each(columns, fn { field, label } ->
      IO.puts "#{String.pad_leading(label, max_width)} #{Map.get(body, field)}"
    end)
  end
end
