defmodule Noaa.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> retrieve_data_from_noaa
    |> sort_by_name_asc
    |> print_data
  end

  def parse_args(argv) do
    { parsed, args, _ } = OptionParser.parse(argv, switches: [ help: :boolean ], aliases: [ h: :help ])

    args_to_internal_format(parsed, args)
  end

  defp args_to_internal_format([ help: true ], _) do
    :help
  end

  defp args_to_internal_format(_, []) do
    :help
  end

  defp args_to_internal_format(_, locations) do
    locations
  end

  def retrieve_data_from_noaa(:help) do
    IO.puts """
    usage: noaa location1 [location2]
    """

    System.halt(0)
  end

  def retrieve_data_from_noaa(locations) do
    Noaa.NoaaData.fetch_data(locations)
  end

  def sort_by_name_asc(location_data) do
    Enum.sort(location_data)
  end

  defp print_data(location_data) do
    Noaa.TableFormatter.print_table(location_data, Noaa.NoaaData.data_columns())
  end
end
