defmodule InvocationTest do
  use ExUnit.Case
  alias Atomix.Invocation.Parser
  @moduletag timeout: 100

  test "12.3.2a Definition name" do
    definition_name_str = "definition_nameABC"
    {:ok, definition_name, _, _, _, _} = Parser.definition_name(definition_name_str)
    assert definition_name == [definition_name: "definition_nameABC"]
  end

  test "12.3.2b Definition" do
    definition_str = "definition_name[(a<>b<>)($d$e) $A$B():00[1] 01[2]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: "definition_name",
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

  test "12.3.2.1 Destination list" do
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

    destination_list_with_conditional_input_str = "$A {$B $C}"

    {:ok, destination_list_with_conditional_input, _, _, _, _} =
      Parser.destination_list(destination_list_with_conditional_input_str)

    assert destination_list_with_conditional_input == [
             destination_list: [
               destination_place: {:name, "A"},
               mutually_exclusive_completeness:
                 {:destination_list,
                  [destination_place: {:name, "B"}, destination_place: {:name, "C"}]}
             ]
           ]
  end

  test "12.3.2 Destination list in parens" do
    destination_list_parens_str = "($R)"

    {:ok, destination_list_parens, _, _, _, _} =
      Parser.destination_list_parens(destination_list_parens_str)

    assert destination_list_parens == [destination_list: [destination_place: {:name, "R"}]]
  end

  test "1.3.2a Invocation List" do
    invocation_list_str =
      "SL(A<>) NOT(A<>) AND(A<> B<>) OR(A<> B<>) XOR(A<> B<>) ADD(A<> B<> carryin<>)"

    {:ok, invocation_list, "", %{}, {1, 0}, _} = Parser.invocation_list(invocation_list_str)

    assert invocation_list == [
             invocatioon: [invocation_name: "SL", source_list: [source_place: [name: "A"]]],
             invocatioon: [invocation_name: "NOT", source_list: [source_place: [name: "A"]]],
             invocatioon: [
               invocation_name: "AND",
               source_list: [source_place: [name: "A"], source_place: [name: "B"]]
             ],
             invocatioon: [
               invocation_name: "OR",
               source_list: [source_place: [name: "A"], source_place: [name: "B"]]
             ],
             invocatioon: [
               invocation_name: "XOR",
               source_list: [source_place: [name: "A"], source_place: [name: "B"]]
             ],
             invocatioon: [
               invocation_name: "ADD",
               source_list: [
                 source_place: [name: "A"],
                 source_place: [name: "B"],
                 source_place: [name: "carryin"]
               ]
             ]
           ]
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

  test "12.14a Arbitrated Places" do
    invocation_str_1 = "Arbiter({{$place1 $place2}})(next<>)"
    {:ok, invocation_1, _, _, _, _} = Parser.invocation(invocation_str_1)

    assert invocation_1 == [
             invocatioon: [
               invocation_name: "Arbiter",
               source_list: [
                 mutually_exclusive_completeness: {
                   :source_list,
                   [
                     mutually_exclusive_completeness: {
                       :destination_list,
                       [
                         destination_place: {:name, "place1"},
                         destination_place: {:name, "place2"}
                       ]
                     }
                   ]
                 }
               ]
             ]
           ]
  end

  test "12.14b Arbitrated Places" do
    definition_str_1 = "Arbiter[(placeB<>)($pass) pass<$placeB>:fake[fake]]"
    {:ok, definition_1, _, _, _, _} = Parser.definition(definition_str_1)

    assert definition_1 == [
             definition: [
               definition_name: "Arbiter",
               source_list: [source_place: [name: "placeB"]],
               destination_list: [destination_place: {:name, "pass"}],
               source_place: [name: "pass", content: [destination_place: {:name, "placeB"}]],
               place_of_resolution: [
                 {:constant_definitions, [constant_name: "fake", constant_content: "fake"]}
               ]
             ]
           ]
  end

  test "12.14c Arbitrated Places" do
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
               definition_name: "FULLADD",
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
               definition_name: "AND",
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
               definition_name: "AND",
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
               definition_name: "ANDA",
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
               mutually_exclusive_completeness:
                 {:source_list, [source_place: [name: "B0"], source_place: [name: "B1"]]}
             ]
  end

  test "12.6 Fan-out steering" do
    definition_str = "fanout[(select<>in<>)({$out1 $out2})$select():A[out1<$in>] B[out2<$in>]]"

    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: "fanout",
               source_list: [source_place: [name: "select"], source_place: [name: "in"]],
               destination_list: [
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [destination_place: {:name, "out1"}, destination_place: {:name, "out2"}]}
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
               ]
             ]
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
               definition_name: "fanout",
               source_list: [source_place: [name: "select"], source_place: [name: "in"]],
               destination_list: [
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [
                      destination_place: {:name, "out1"},
                      destination_place: {:name, "out2"},
                      destination_place: {:name, "out3"},
                      destination_place: {:name, "out4"}
                    ]}
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

    expression_str = "#{definition_str} #{invocation_str}"
    {:ok, expression, _, _, _, _} = Parser.expression(expression_str)

    assert expression == [
             expression: [
               definition: [
                 definition_name: "fanout",
                 source_list: [source_place: [name: "select"], source_place: [name: "in"]],
                 destination_list: [
                   mutually_exclusive_completeness:
                     {:destination_list,
                      [
                        destination_place: {:name, "out1"},
                        destination_place: {:name, "out2"},
                        destination_place: {:name, "out3"},
                        destination_place: {:name, "out4"}
                      ]}
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
               ],
               invocation: [
                 invocation_name: "fanout",
                 destination_list: [
                   destination_place: {:name, "select"},
                   destination_place: {:name, "input"}
                 ]
               ]
             ]
           ]
  end

  test "12.12 Serial Bus" do
    invocation_str = "fanin($selin {$in1 $in2})(serialmid<>)"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocation: [
               invocation_name: "fanin",
               destination_list: [
                 destination_place: {:name, "selin"},
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [destination_place: {:name, "in1"}, destination_place: {:name, "in2"}]}
               ],
               source_list: [source_place: [name: "serialmid"]]
             ]
           ]

    invocation_str_2 = "fanout($selout $serialmid)({out1<> out2<> out3<> out4<>})"
    {:ok, invocation_2, _, _, _, _} = Parser.invocation(invocation_str_2)

    assert invocation_2 == [
             invocation: [
               {:invocation_name, "fanout"},
               {
                 :destination_list,
                 [destination_place: {:name, "selout"}, destination_place: {:name, "serialmid"}]
               },
               {:source_list,
                [
                  mutually_exclusive_completeness:
                    {:source_list,
                     [
                       source_place: [name: "out1"],
                       source_place: [name: "out2"],
                       source_place: [name: "out3"],
                       source_place: [name: "out4"]
                     ]}
                ]}
             ]
           ]
  end

  test "12.13 Parallel Bus" do
    invocation_str_1 = "fanout($seloutA $srcA)({outA1<> outA2<> outA3<> outA4<> outA5<>})"
    {:ok, invocation_1, _, _, _, _} = Parser.invocation(invocation_str_1)

    assert invocation_1 == [
             invocation: [
               {:invocation_name, "fanout"},
               {
                 :destination_list,
                 [
                   destination_place: {:name, "seloutA"},
                   destination_place: {:name, "srcA"}
                 ]
               },
               {:source_list,
                [
                  mutually_exclusive_completeness:
                    {:source_list,
                     [
                       source_place: [name: "outA1"],
                       source_place: [name: "outA2"],
                       source_place: [name: "outA3"],
                       source_place: [name: "outA4"],
                       source_place: [name: "outA5"]
                     ]}
                ]}
             ]
           ]

    invocation_str_2 = "fanout($seloutB $srcB)(outB1 outB2<> outB3<> outB4<> outB5<>"
    {:ok, invocation_2, _, _, _, _} = Parser.invocation(invocation_str_2)

    assert invocation_2 == [
             invocation: [
               invocation_name: "fanout",
               destination_list: [
                 destination_place: {:name, "seloutB"},
                 destination_place: {:name, "srcB"}
               ]
             ]
           ]

    invocation_str_3 = "fan_in($selin1 {$outA1 $outB1})(dest1<>)"
    {:ok, invocation_3, _, _, _, _} = Parser.invocation(invocation_str_3)

    assert invocation_3 == [
             invocation: [
               invocation_name: "fan_in",
               destination_list: [
                 destination_place: {:name, "selin1"},
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [destination_place: {:name, "outA1"}, destination_place: {:name, "outB1"}]}
               ],
               source_list: [source_place: [name: "dest1"]]
             ]
           ]

    invocation_str_4 = "fanin($selin2 {$outA2 $outB2})(dest2<>)"
    {:ok, invocation_4, _, _, _, _} = Parser.invocation(invocation_str_4)

    assert invocation_4 == [
             invocation: [
               invocation_name: "fanin",
               destination_list: [
                 destination_place: {:name, "selin2"},
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [destination_place: {:name, "outA2"}, destination_place: {:name, "outB2"}]}
               ],
               source_list: [source_place: [name: "dest2"]]
             ]
           ]

    invocation_str_5 = "fanin($selin3 {$outA3 $outB3})(dest3<>)"
    {:ok, invocation_5, _, _, _, _} = Parser.invocation(invocation_str_5)

    assert invocation_5 == [
             invocation: [
               invocation_name: "fanin",
               destination_list: [
                 destination_place: {:name, "selin3"},
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [destination_place: {:name, "outA3"}, destination_place: {:name, "outB3"}]}
               ],
               source_list: [source_place: [name: "dest3"]]
             ]
           ]

    invocation_str_6 = "fanin($selin4 {$outA4 $outB4})(dest4<>)"
    {:ok, invocation_6, _, _, _, _} = Parser.invocation(invocation_str_6)

    assert invocation_6 == [
             invocation: [
               invocation_name: "fanin",
               destination_list: [
                 destination_place: {:name, "selin4"},
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [destination_place: {:name, "outA4"}, destination_place: {:name, "outB4"}]}
               ],
               source_list: [source_place: [name: "dest4"]]
             ]
           ]

    invocation_str_7 = "fanin($selin5 {$outA5 $outB5})(dest5<>)"
    {:ok, invocation_7, _, _, _, _} = Parser.invocation(invocation_str_7)

    assert invocation_7 == [
             invocation: [
               invocation_name: "fanin",
               destination_list: [
                 destination_place: {:name, "selin5"},
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [destination_place: {:name, "outA5"}, destination_place: {:name, "outB5"}]}
               ],
               source_list: [source_place: [name: "dest5"]]
             ]
           ]
  end

  # not sure about this yet but looks like it takes the source and
  # returns the result to the place of invocation
  test "12.15aa Invocation with a single input and single output" do
    invocation_str = "SL(A<>)"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocatioon: [invocation_name: "SL", source_list: [source_place: [name: "A"]]]
           ]
  end

  test "12.15b Mutually exclusive completeness with invocations" do
    completeness_str =
      "{SL(A<>) NOT(A<>) AND(A<> B<>) OR(A<> B<>) XOR(A<> B<>) ADD(A<> B<> carryin<>)}"

    {:ok, completeness, _, _, _, _} = Parser.mutually_exclusive_completeness(completeness_str)

    assert completeness == [
             mutually_exclusive_completeness:
               {:destination_list,
                [
                  invocatioon: [invocation_name: "SL", source_list: [source_place: [name: "A"]]],
                  invocatioon: [invocation_name: "NOT", source_list: [source_place: [name: "A"]]],
                  invocatioon: [
                    invocation_name: "AND",
                    source_list: [source_place: [name: "A"], source_place: [name: "B"]]
                  ],
                  invocatioon: [
                    invocation_name: "OR",
                    source_list: [source_place: [name: "A"], source_place: [name: "B"]]
                  ],
                  invocatioon: [
                    invocation_name: "XOR",
                    source_list: [source_place: [name: "A"], source_place: [name: "B"]]
                  ],
                  invocatioon: [
                    invocation_name: "ADD",
                    source_list: [
                      source_place: [name: "A"],
                      source_place: [name: "B"],
                      source_place: [name: "carryin"]
                    ]
                  ]
                ]}
           ]
  end

  test "12.15c Definition of ALU with complex completeness relationships" do
    invocation_str = "ALU(ADD, $A $B $carryin)(output<> carryout<>)"
    {:ok, alu_invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert alu_invocation == [
             invocation: [
               invocation_name: "ALU",
               destination_list: [
                 constant_content: "ADD",
                 destination_place: {:name, "A"},
                 destination_place: {:name, "B"},
                 destination_place: {:name, "carryin"}
               ],
               source_list: [source_place: [name: "output"], source_place: [name: "carryout"]]
             ]
           ]

    definition_str =
      "ALU[(command<> {SL(A<>) NOT(A<>) AND(A<> B<>) OR(A<> B<>) XOR(A<> B<>) ADD(A<> B<> carryin<>)}) ({SL($result) SR($result) NOT($result) OR($result) AND($result) XOR($result) ADD($result $carryout)})$fake1$fake2():00[1]]"

    {:ok, alu_definition, _, _, _, _} = Parser.definition(definition_str)

    assert alu_definition == [
             definition: [
               definition_name: "ALU",
               source_list: [
                 source_place: [name: "command"],
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [
                      invocatioon: [
                        invocation_name: "SL",
                        source_list: [source_place: [name: "A"]]
                      ],
                      invocatioon: [
                        invocation_name: "NOT",
                        source_list: [source_place: [name: "A"]]
                      ],
                      invocatioon: [
                        invocation_name: "AND",
                        source_list: [source_place: [name: "A"], source_place: [name: "B"]]
                      ],
                      invocatioon: [
                        invocation_name: "OR",
                        source_list: [source_place: [name: "A"], source_place: [name: "B"]]
                      ],
                      invocatioon: [
                        invocation_name: "XOR",
                        source_list: [source_place: [name: "A"], source_place: [name: "B"]]
                      ],
                      invocatioon: [
                        invocation_name: "ADD",
                        source_list: [
                          source_place: [name: "A"],
                          source_place: [name: "B"],
                          source_place: [name: "carryin"]
                        ]
                      ]
                    ]}
               ],
               destination_list: [
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [
                      invocation: [
                        invocation_name: "SL",
                        destination_list: [destination_place: {:name, "result"}]
                      ],
                      invocation: [
                        invocation_name: "SR",
                        destination_list: [destination_place: {:name, "result"}]
                      ],
                      invocation: [
                        invocation_name: "NOT",
                        destination_list: [destination_place: {:name, "result"}]
                      ],
                      invocation: [
                        invocation_name: "OR",
                        destination_list: [destination_place: {:name, "result"}]
                      ],
                      invocation: [
                        invocation_name: "AND",
                        destination_list: [destination_place: {:name, "result"}]
                      ],
                      invocation: [
                        invocation_name: "XOR",
                        destination_list: [destination_place: {:name, "result"}]
                      ],
                      invocation: [
                        invocation_name: "ADD",
                        destination_list: [
                          destination_place: {:name, "result"},
                          destination_place: {:name, "carryout"}
                        ]
                      ]
                    ]}
               ],
               conditional_invocation: [
                 destination_place: {:name, "fake1"},
                 destination_place: {:name, "fake2"}
               ],
               place_of_resolution: [
                 constant_definitions: [constant_name: "00", constant_content: "1"]
               ]
             ]
           ]
  end

  test "12.16 Example with occasional source place" do
    invocation_str = "report($answer)(OK<> NO<>)"
    {:ok, invocation, _, _, _, _} = Parser.invocation(invocation_str)

    assert invocation == [
             invocation: [
               invocation_name: "report",
               destination_list: [destination_place: {:name, "answer"}],
               source_list: [source_place: [name: "OK"], source_place: [name: "NO"]]
             ]
           ]

    definition_str = "report[(answer<>)({$YES $NO})$answer():yes[yes<yes>] no[NO<>]]"
    {:ok, definition, _, _, _, _} = Parser.definition(definition_str)

    assert definition == [
             definition: [
               definition_name: "report",
               source_list: [source_place: [name: "answer"]],
               destination_list: [
                 mutually_exclusive_completeness:
                   {:destination_list,
                    [destination_place: {:name, "YES"}, destination_place: {:name, "NO"}]}
               ],
               conditional_invocation: [destination_place: {:name, "answer"}],
               place_of_resolution: [
                 constant_definitions: [
                   constant_name: "yes",
                   source_place: [name: "yes", content: [constant_content: "yes"]],
                   constant_name: "no",
                   source_place: [name: "NO"]
                 ]
               ]
             ]
           ]
  end
end
