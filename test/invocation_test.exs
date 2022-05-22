defmodule InvocationTest do
  use ExUnit.Case
  alias Atomix.Invocation.Parser

  test "definition" do
    definition_str = "definition_name[(a<>b<>)($d$e) + : 00[1] 01[2]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)
    definition_name = definition[:definition_name]

    assert definition_name == "definition_name"

    source_list = definition[:source_list]
    assert source_list == [source_place: [name: "a"], source_place: [name: "b"]]
    destination_list = definition[:destination_list]

    assert destination_list == [
             destination_place: {:name, "d"},
             destination_place: {:name, "e"}
           ]

    place_of_resolution = definition[:place_of_resolution]
    assert place_of_resolution == "+"

    constant_definitions = definition[:constant_definitions]
    assert constant_definitions == [
             constant_name: "00",
             constant_content: "1",
             constant_name: "01",
             constant_content: "2"
           ]
  end
end
