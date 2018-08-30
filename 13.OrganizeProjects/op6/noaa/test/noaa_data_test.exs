defmodule NoaaDataTest do
  use ExUnit.Case
  doctest Noaa.NoaaData

  import Noaa.NoaaData, only: [ extract_field: 2, parse_body: 2 ]

  test "XML field data extraction" do
    assert extract_field("<root><a>aa</a><b>bb</b></root>", "b") == %{ "b" => "bb" }
  end

  test "XML body extraction" do
    assert parse_body("<root><a>aa</a><b>bb</b><c>cc</c></root>", ["a", "c"]) ==
      %{ "a" => "aa", "c" => "cc" }
  end
end
