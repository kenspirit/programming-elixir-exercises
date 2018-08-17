defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispath to
  the various functions that end up generating a table of
  the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args
    # |> IO.puts
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise, it is a github user name, project name and (optionally) the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [ help: :boolean ], aliases: [ h: :help ])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([ user, project, count ]) do
    { user, project, String.to_integer(count) }
  end

  def args_to_internal_representation([ user, project ]) do
    { user, project, @default_count }
  end

  def args_to_internal_representation(_) do # bad arg or --help
    :help
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """

    System.halt(0)
  end

  def process({ user, project, count }) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> pick_table_fields()
    |> print_table()
  end

  def decode_response({ :ok, body }), do: body

  def decode_response({ :error, error }) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end

  def sort_into_descending_order(issues) do
    issues
    |> Enum.sort(fn i1, i2 ->
        i1["created_at"] > i2["created_at"]
      end)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end

  def pick_table_fields(list) do
    list
    |> Enum.map(fn item -> %{ "number" => Integer.to_string(item["number"]), "created_at" => item["created_at"], "title" => item["title"] } end)
  end

  #  #  | created_at             | title
  # ----+------------------------+-----------------------------------------
  # 889 | 2013-03-16T22: 03: 13Z | MIX_PATH environment variable (of sorts) 
  # 892 | 2013-03-20T19: 22: 07Z | Enhanced mix test --cover
  # 893 | 2013-03-21T06: 23: 00Z | mix test time reports
  # 898 | 2013-03-23T19: 19: 08Z | Add mix compile --warnings-as-errors
  def print_table(list) do
    max_len = Enum.reduce(list, [ 0, 0, 0 ], fn item, acc ->
      [
        max(String.length(item["number"]), Enum.at(acc, 0)),
        max(String.length(item["created_at"]), Enum.at(acc, 1)),
        max(String.length(item["title"]), Enum.at(acc, 2))
      ]
    end)

    list = [%{ "number" => "#", "created_at" => "created_at", "title" => "title"}, %{ "number" => "-", "created_at" => "-", "title" => "-", "padding" => "-"}] ++ list

    Enum.each(list, &(print_line(&1, max_len)))
  end

  def print_line(item, max_len) do
    %{ "number" => number, "created_at" => created_at, "title" => title } = item

    padding = item["padding"] || " "
    sep = if item["padding"], do: "+", else: "|"

    IO.puts "#{get_col(number, max_len, 0, padding)}#{sep}#{get_col(created_at, max_len, 1, padding)}#{sep}#{get_col(title, max_len, 2, padding)}"
  end

  def get_col(item, max_len, idx, padding) do
    "#{padding}#{String.pad_trailing(item, Enum.at(max_len, idx), padding)}#{padding}"
  end
end
