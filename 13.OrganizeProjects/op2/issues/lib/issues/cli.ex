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
  end
end
