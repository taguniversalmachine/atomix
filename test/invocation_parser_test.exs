defmodule InvocationTest do
  use ExUnit.Case
  alias Atomix.Invocation.Parser

  test "definition name" do
    definition_name_str = "definition_nameABC"
    {:ok, definition_nane, _, _, _, _} = Parser.definition_name(definition_name_str)
    assert definition_name = "XXX"
  end

  test "12.3.2 Definition - place of resolution" do
    place_of_resolution_str = " $A$B() "
    {:ok, place_of_resolution, _, _, _, _} = Parser.place_of_resolution(place_of_resolution_str)

    assert place_of_resolution == [
             place_of_resolution: [
               {:conditional_invocation,
                [
                  destination_list: [
                    destination_place: {:name, "A"},
                    destination_place: {:name, "B"}
                  ]
                ]}
             ]
           ]
  end

  @tag timeout: 10
  test "12.3.2 Definition" do
    definition_str = "definition_name[(a<>b<>)($d$e) $A$B():00[1] 01[2]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)
    assert definition == "XX"
  end

  test "Source list" do
    source_list_str = "A<> B<>"
    {:ok, expression, _, _, _, _} = Parser.source_list(source_list_str)
    assert expression == [source_list: [source_place: [name: "A"], source_place: [name: "B"]]]
  end

  test "Source list parens" do
    source_list_parens_str = "(A<> B<> C<>)"
    {:ok, expression, _, _, _, _} = Parser.source_list_parens(source_list_parens_str)

    assert expression == [
             source_list: [
               source_place: [name: "A"],
               source_place: [name: "B"],
               source_place: [name: "C"]
             ]
           ]
  end

  test "Destination list" do
    destination_list_str = "$A $B"
    {:ok, expression, _, _, _, _} = Parser.destination_list(destination_list_str)

    assert expression == [
             destination_list: [destination_place: {:name, "A"}, destination_place: {:name, "B"}]
           ]

    destination_list_str = "$A$B"
    {:ok, expression, _, _, _, _} = Parser.destination_list(destination_list_str)

    assert expression == [
             destination_list: [destination_place: {:name, "A"}, destination_place: {:name, "B"}]
           ]

    destination_list_str = "$A,$B,$C"
    {:ok, expression, _, _, _, _} = Parser.destination_list(destination_list_str)

    assert expression == [
             destination_list: [
               destination_place: {:name, "A"},
               destination_place: {:name, "B"},
               destination_place: {:name, "C"}
             ]
           ]

    destination_list_str = " $A,$B "
    {:ok, expression, _, _, _, _} = Parser.destination_list(destination_list_str)

    assert expression == [
             destination_list: [destination_place: {:name, "A"}, destination_place: {:name, "B"}]
           ]
  end

  test "Destination list in parens" do
    destination_list_parens_str = "($R)"

    {:ok, destination_list_parens, _, _, _, _} =
      Parser.destination_list_parens(destination_list_parens_str)

    assert destination_list_parens == [destination_list: [destination_place: {:name, "R"}]]
  end

  test "Conditional invocation" do
    conditional_invocation_str = "$select()"

    {:ok, conditional_invocation, "", %{}, {1, 0}, _} =
      Parser.conditional_invocation(conditional_invocation_str)

    assert conditional_invocation == [
             conditional_invocation: [destination_list: [destination_place: {:name, "select"}]]
           ]

    conditional_invocation_str = "$A$B()"

    {:ok, conditional_invocation, "", %{}, {1, 0}, _} =
      Parser.conditional_invocation(conditional_invocation_str)

    assert conditional_invocation == [
             conditional_invocation: [
               destination_list: [
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"}
               ]
             ]
           ]
  end

  test "Unnamed empty source place" do
    source_place_str = "<>"
    {:ok, expression, _, _, _, _} = Parser.unnamed_empty_source_place(source_place_str)

    assert expression == [unnamed_source_place: []]
  end

  test "Unnamed source place with conditional invocation" do
    source_place_str = "<$A$B()>"
    {:ok, expression, _, _, _, _} = Parser.unnamed_source_place(source_place_str)

    assert expression == [
             unnamed_source_place: [
               conditional_invocation: [
                 destination_list: [
                   destination_place: {:name, "A"},
                   destination_place: {:name, "B"}
                 ]
               ]
             ]
           ]
  end

  test "12.14 arbitration" do
    arbitration_str = "{{$A $B}}"
    {:ok, expression, _, _, _, _} = Parser.arbitration(arbitration_str)
    assert expression = []
  end

  test "12.1 Unnamed Source Place in an Invocation" do
    invocation_str = "FULLADD(0,1,0)(<>CARRYOUT<>)"
    definition_str = "FULLADD[(X<>Y<>C<>)($SUM $CARRY):]"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert invocation == [
             invocation: [
               invocation_name: "FULLADD",
               destination_list: [
                 constant_content: "0",
                 constant_content: "1",
                 constant_content: "0"
               ],
               source_list: [unnamed_source_place: [], source_place: [name: "CARRYOUT"]]
             ]
           ]

    assert definition == [
             definition: [
               definition_name: ["FULLADD"],
               source_list: [
                 source_place: [name: "X"],
                 source_place: [name: "Y"],
                 source_place: [name: "C"]
               ],
               destination_list: [
                 destination_place: {:name, "SUM"},
                 destination_place: {:name, "CARRY"}
               ],
               place_of_resolution: [],
               constant_definitions: []
             ]
           ]
  end

  test "12.2a Expressing a single return to place of invocation - invocation" do
    invocation_str = "AND($A $B)(<>)"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocation: [
               invocation_name: "AND",
               destination_list: [
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"}
               ],
               source_list: [unnamed_source_place: []]
             ]
           ]
  end

  test "12.2b Expressing a single return to place of invocation - definition" do
    definition_str = "AND[(X<>Y<>C<>)($R):]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == "XX"
  end

  test "12.3 Further abbreviated expression of a single return to place of invocation" do
    invocation_str = "AND($A$B)"
    definition_str = "AND[(X<>Y<>)$a$b():]"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert invocation == [
             invocation: [
               invocation_name: "AND",
               destination_list: [
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"}
               ]
             ]
           ]

    assert definition == [
             definition: [
               definition_name: ["AND"],
               source_list: [source_place: [name: "X"], source_place: [name: "Y"]],
               conditional_invocation: [
                 destination_list: [
                   destination_place: {:name, "a"},
                   destination_place: {:name, "b"}
                 ]
               ],
               place_of_resolution: [],
               constant_definitions: []
             ]
           ]
  end

  test "12.4 Nested invocations" do
    nested_invocation_str = "A(B($E)))"
    {:ok, nested_invocation, _, _, _, _} = Parser.invocation(nested_invocation_str)

    assert nested_invocation == [
             invocation: [
               invocation_name: "A",
               invocation: [
                 invocation_name: "B",
                 destination_list: [destination_place: {:name, "E"}]
               ]
             ]
           ]

    nested_invocation_str = "OR(AND(NOT($X)),AND($X,NOT($Y))))"
    {:ok, nested_invocation, _, _, _, _} = Parser.invocation(nested_invocation_str)

    assert nested_invocation == [
             invocation: [
               invocation_name: "A",
               invocation: [
                 invocation_name: "B",
                 destination_list: [destination_place: {:name, "E"}]
               ]
             ]
           ]
  end

  test "12.5 AND function with value transform rule definitions" do
    definition_str = "ANDA[(A<>B<>)(<$C$D()>) : 00[0] 01[0] 10[0] 11[1]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition_name: "ANDA",
             source_list: [source_place: [name: "A"], source_place: [name: "B"]],
             unnamed_source_place: [
               conditional_invocation: [
                 destination_list: [
                   destination_place: {:name, "C"},
                   destination_place: {:name, "D"}
                 ]
               ]
             ],
             place_of_resolution: [],
             constant_definitions: [
               constant_name: "00",
               constant_content: "0",
               constant_name: "01",
               constant_content: "0",
               constant_name: "10",
               constant_content: "0",
               constant_name: "11",
               constant_content: "1"
             ]
           ]
  end

  test "12.3.4 Constant Definitions" do
    constant_definition_str = "A[constant] B[constant2]"
    {:ok, constant_definition, _, _, _, _} = Parser.constant_definitions(constant_definition_str)

    assert constant_definition == [
             constant_definitions: [
               {:constant_name, "A"},
               {:constant_content, "constant"},
               {:constant_name, "B"},
               {:constant_content, "constant2"}
             ]
           ]
  end

  test "12.5.2 Mutually exclusive completeness" do
    mutually_exclusive_completeness_str = "{B0<> B1<>}"

    {:ok, mutually_exclusive_completeness, _, _, _, _} =
      Parser.mutually_exclusive_completeness(mutually_exclusive_completeness_str)

    assert mutually_exclusive_completeness ==
             [
               mutually_exclusive_completeness: [
                 source_list: [source_place: [name: "B0"], source_place: [name: "B1"]]
               ]
             ]
  end

  test "12.6 Fan-out steering" do
    definition_str = "fanout[(select<>in<>)({$out1 $out2}) $select(): A[out1<$in>] B[out2<$in>]]"

    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)
    assert definition == "3"
  end

  test "12.14 arbitrated places" do
    arbitration_expr_str =
      "Arbiter({{$place1 $place2}})(next <>) $next Arbiter[(placeB<>($pass) pass<$placeB>:]"

    {:ok, expression, _, _, _, _} = Parser.expression(arbitration_expr_str)
    assert expression == []
  end
end
