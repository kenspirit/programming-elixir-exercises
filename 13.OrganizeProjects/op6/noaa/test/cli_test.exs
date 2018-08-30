defmodule CliTest do
  use ExUnit.Case
  doctest Noaa

  import Noaa.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) === :help

    assert parse_args(["--help", "anything"]) === :help
  end

  test "[] returned if no option is given" do
    assert parse_args([]) === :help
  end

  test "comma-separated list items are returned" do
    assert parse_args(["a", "b", "c"]) === ["a", "b", "c"]
  end
end
