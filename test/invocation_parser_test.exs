defmodule InvocationTest do
  use ExUnit.Case
  alias Atomix.Invocation.Parser
  @moduletag timeout: 100

  test "12.3.2a Definition name" do
    definition_name_str = "definition_nameABC"
    {:ok, definition_name, _, _, _, _} = Parser.definition_name(definition_name_str)
    assert definition_name == [definition_name: ["definition_nameABC"]]
  end

  test "12.3.2b Definition" do
    definition_str = "definition_name[(a<>b<>)($d$e) $A$B():00[1] 01[2]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: ["definition_name"],
               source_list: [source_place: [name: "a"], source_place: [name: "b"]],
               destination_list: [
                 destination_place: {:name, "d"},
                 destination_place: {:name, "e"}
               ],
               conditional_invocation: [
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"}
               ],
               place_of_resolution: [
                 constant_definitions: [
                   constant_name: "00",
                   constant_content: "1",
                   constant_name: "01",
                   constant_content: "2"
                 ]
               ]
             ]
           ]
  end

  test "12.3.2 Definition - place of resolution" do
    place_of_resolution_str = "$A$B()"
    {:ok, place_of_resolution, _, _, _, _} = Parser.place_of_resolution(place_of_resolution_str)

    assert place_of_resolution == [
             place_of_resolution: [
               conditional_invocation: [
                 {:destination_place, {:name, "A"}},
                 {:destination_place, {:name, "B"}}
               ]
             ]
           ]
  end

  test "12.3.2 Source list" do
    source_list_str = "A<> B<>"
    {:ok, expression, _, _, _, _} = Parser.source_list(source_list_str)
    assert expression == [source_list: [source_place: [name: "A"], source_place: [name: "B"]]]
  end

  test "12.2.3 Source list with unnamed source place" do
    source_list_str = "A<> B<> <>"
    {:ok, expression, _, _, _, _} = Parser.source_list(source_list_str)

    assert expression == [
             source_list: [
               source_place: [name: "A"],
               source_place: [name: "B"],
               unnamed_source_place: []
             ]
           ]
  end

  test "12.3.2 Source list parens" do
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

  test "12.3.2 Destination list" do
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

  test "12.3.2 Destination list in parens" do
    destination_list_parens_str = "($R)"

    {:ok, destination_list_parens, _, _, _, _} =
      Parser.destination_list_parens(destination_list_parens_str)

    assert destination_list_parens == [destination_list: [destination_place: {:name, "R"}]]
  end

  test "12.12? Conditional invocation" do
    conditional_invocation_str = "$select()"

    {:ok, conditional_invocation, "", %{}, {1, 0}, _} =
      Parser.conditional_invocation(conditional_invocation_str)

    assert conditional_invocation == [
             conditional_invocation: [destination_place: {:name, "select"}]
           ]

    conditional_invocation_str = "$X$Y()"

    {:ok, conditional_invocation, "", %{}, {1, 0}, _} =
      Parser.conditional_invocation(conditional_invocation_str)

    assert conditional_invocation == [
             conditional_invocation: [
               {:destination_place, {:name, "X"}},
               {:destination_place, {:name, "Y"}}
             ]
           ]
  end

  test "Unnamed empty source place" do
    source_place_str = "<>"
    {:ok, expression, _, _, _, _} = Parser.unnamed_empty_source_place(source_place_str)

    assert expression == [unnamed_source_place: []]
  end

  test "12.13? Unnamed source place with conditional invocation" do
    source_place_str = "<$A$B()>"

    {:ok, expression, _, _, _, _} =
      Parser.unnamed_source_place_with_conditional_invocation(source_place_str)

    assert expression == [
             unnamed_source_place: [
               conditional_invocation: [
                 {:destination_place, {:name, "A"}},
                 {:destination_place, {:name, "B"}}
               ]
             ]
           ]
  end

  test "12.14 arbitration" do
    arbitration_str = "{{$A $B}}"
    {:ok, expression, _, _, _, _} = Parser.arbitration(arbitration_str)
    assert expression = []
  end

  test "12.1a Unnamed Source Place in an Invocation" do
    invocation_str = "FULLADD(0,1,0)(<>CARRYOUT<>)"

    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

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
  end

  test "12.1b Unnamed Source Place in a definition" do
    definition_str = "FULLADD[(X<>Y<>C<>)($SUM $CARRY)<$X$Y()>:00[1]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

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
               unnamed_source_place: [
                 {:conditional_invocation,
                  [destination_place: {:name, "X"}, destination_place: {:name, "Y"}]}
               ],
               place_of_resolution: [
                 {:constant_definitions, [constant_name: "00", constant_content: "1"]}
               ]
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
    definition_str = "AND[(X<>Y<>C<>)($R)<$A$B()>:00[1] 01[1] 10[1] 11[1]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: ["AND"],
               source_list: [
                 source_place: [name: "X"],
                 source_place: [name: "Y"],
                 source_place: [name: "C"]
               ],
               destination_list: [destination_place: {:name, "R"}],
               unnamed_source_place: [
                 conditional_invocation: [
                   destination_place: {:name, "A"},
                   destination_place: {:name, "B"}
                 ]
               ],
               place_of_resolution: [
                 constant_definitions: [
                   constant_name: "00",
                   constant_content: "1",
                   constant_name: "01",
                   constant_content: "1",
                   constant_name: "10",
                   constant_content: "1",
                   constant_name: "11",
                   constant_content: "1"
                 ]
               ]
             ]
           ]
  end

  test "12.3a Further abbreviated expression of a single return to place of invocation" do
    invocation_str = "AND($A$B)"

    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocation: [
               invocation_name: "AND",
               destination_list: [
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"}
               ]
             ]
           ]
  end

  test "12.3.b.1 Invocation with multiple destination places" do
    invocation_str = "AND($A,$B)"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocation: [
               invocation_name: "AND",
               destination_list: [
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"}
               ]
             ]
           ]

    invocation_str = "AND($A $B)"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocation: [
               invocation_name: "AND",
               destination_list: [
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"}
               ]
             ]
           ]
  end

  test "12.3b Further abbreviated expression of a single return to place of invocation" do
    definition_str = "AND[(X<>Y<>)$a$b():00[1]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: ["AND"],
               source_list: [
                 source_place: [name: "X"],
                 source_place: [name: "Y"]
               ],
               conditional_invocation: [
                 {:destination_place, {:name, "a"}},
                 {:destination_place, {:name, "b"}}
               ],
               place_of_resolution: [
                 {:constant_definitions, [constant_name: "00", constant_content: "1"]}
               ]
             ]
           ]
  end

  test "12.4a Nested invocations" do
    nested_invocation_str = "X(Y($Z)))"
    {:ok, nested_invocation, _, _, _, _} = Parser.invocation(nested_invocation_str)

    assert nested_invocation == [
             invocation: [
               invocation_name: "X",
               destination_list: [
                 invocation: [
                   invocation_name: "Y",
                   destination_list: [destination_place: {:name, "Z"}]
                 ]
               ]
             ]
           ]
  end

  test "12.4b Multiple Nested invocations" do
    nested_invocation_str = "OR(AND(NOT($X)),AND($X,NOT($Y))))"
    {:ok, nested_invocation, _, _, _, _} = Parser.invocation(nested_invocation_str)

    assert nested_invocation == [
             invocation: [
               invocation_name: "OR",
               destination_list: [
                 invocation: [
                   invocation_name: "AND",
                   destination_list: [
                     invocation: [
                       invocation_name: "NOT",
                       destination_list: [destination_place: {:name, "X"}]
                     ]
                   ]
                 ],
                 invocation: [
                   {:invocation_name, "AND"},
                   {:destination_list,
                    [
                      destination_place: {:name, "X"},
                      invocation: [
                        invocation_name: "NOT",
                        destination_list: [destination_place: {:name, "Y"}]
                      ]
                    ]}
                 ]
               ]
             ]
           ]
  end

  test "12.5 AND function with value transform rule definitions" do
    definition_str = "ANDA[(A<>B<>)<$C$D()>:00[0] 01[0] 10[0] 11[1]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: ["ANDA"],
               source_list: [source_place: [name: "A"], source_place: [name: "B"]],
               unnamed_source_place: [
                 conditional_invocation: [
                   destination_place: {:name, "C"},
                   destination_place: {:name, "D"}
                 ]
               ],
               place_of_resolution: [
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
             ]
           ]
  end

  test "12.3.4 Constant Definitions" do
    constant_definition_str = "A[1] B[0]"
    {:ok, constant_definition, _, _, _, _} = Parser.constant_definitions(constant_definition_str)

    assert constant_definition == [
             constant_definitions: [
               {:constant_name, "A"},
               {:constant_content, "1"},
               {:constant_name, "B"},
               {:constant_content, "0"}
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
    definition_str = "fanout[(select<>in<>)({$out1 $out2}) $select():A[out1<$in>] B[out2<$in>]]"

    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: ["fanout"],
               source_list: [source_place: [name: "select"], source_place: [name: "in"]],
               destination_list: [
                 conditional_input: [
                   destination_list: [
                     destination_place: {:name, "out1"},
                     destination_place: {:name, "out2"}
                   ]
                 ]
               ],
               conditional_invocation: [destination_place: {:name, "select"}],
               place_of_resolution: [
                 constant_definitions: [
                   constant_name: "A",
                   source_place: [name: "out1", content: [destination_place: {:name, "in"}]],
                   constant_name: "B",
                   source_place: [name: "out2", content: [destination_place: {:name, "in"}]]
                 ]
               ]
             ]
           ]
  end

  @tag timeout: 100
  test "12.7 Comma-delimited constants" do
    invocation_str = "ProcX($A $B, NT, EW)()"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocation: [
               invocation_name: "ProcX",
               destination_list: [
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"},
                 constant_content: "NT",
                 constant_content: "EW"
               ],
               source_list: []
             ]
           ]
  end

  test "12.14a arbitrated places" do
    arbitration_expr_str = "{{$place1 $place2}}"

    {:ok, expression, _, _, _, _} = Parser.arbitration(arbitration_expr_str)

    assert expression == [
             {:arbitration,
              [
                destination_list: [
                  destination_place: {:name, "place1"},
                  destination_place: {:name, "place2"}
                ]
              ]}
           ]
  end

  test "12.11 Controlled fan-out expression" do
    invocation_str = "fanout($select $input)({output1<> output2<> output3<> output4<>"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocation: [
               invocation_name: "fanout",
               destination_list: [
                 destination_place: {:name, "select"},
                 destination_place: {:name, "input"}
               ]
             ]
           ]

    definition_str =
      "fanout[(select<> in<>)({$out1 $out2 $out3 $out4})$select():A[out1<$in>] B[out2<$in>] C[out3<$in>] D[out4<$in>]]"

    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: ["fanout"],
               source_list: [source_place: [name: "select"], source_place: [name: "in"]],
               destination_list: [
                 conditional_input: [
                   destination_list: [
                     destination_place: {:name, "out1"},
                     destination_place: {:name, "out2"},
                     destination_place: {:name, "out3"},
                     destination_place: {:name, "out4"}
                   ]
                 ]
               ],
               conditional_invocation: [destination_place: {:name, "select"}],
               place_of_resolution: [
                 constant_definitions: [
                   constant_name: "A",
                   source_place: [name: "out1", content: [destination_place: {:name, "in"}]],
                   constant_name: "B",
                   source_place: [name: "out2", content: [destination_place: {:name, "in"}]],
                   constant_name: "C",
                   source_place: [name: "out3", content: [destination_place: {:name, "in"}]],
                   constant_name: "D",
                   source_place: [name: "out4", content: [destination_place: {:name, "in"}]]
                 ]
               ]
             ]
           ]
  end
end
