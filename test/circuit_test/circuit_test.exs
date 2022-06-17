defmodule Atomix.CircuitTest do
  use ExUnit.Case
  alias Atomix.Invocation.Circuit

  test "circuit" do
    circuit_str = "XOR($A $B)(C<>) XOR[(A<> B<>)($C) $A$B():00[0] 01[1] 10[1] 11[0]]"
    expr = Circuit.expression(circuit_str)

    assert expr == [
             expression: [
               invocation: [
                 invocation_name: "XOR",
                 destination_list: [
                   destination_place: {:name, "A"},
                   destination_place: {:name, "B"}
                 ],
                 source_list: [source_place: [name: "C"]]
               ],
               definition: [
                 definition_name: "XOR",
                 source_list: [
                   source_place: [name: "A"],
                   source_place: [name: "B"]
                 ],
                 destination_list: [destination_place: {:name, "C"}],
                 conditional_invocation: [
                   destination_place: {:name, "A"},
                   destination_place: {:name, "B"}
                 ],
                 place_of_resolution: [
                   constant_definitions: [
                     constant_name: "00",
                     constant_content: "0",
                     constant_name: "01",
                     constant_content: "1",
                     constant_name: "10",
                     constant_content: "1",
                     constant_name: "11",
                     constant_content: "0"
                   ]
                 ]
               ]
             ]
           ]

    assert Circuit.check(expr)
  end

  test "get invocations" do
    circuit_str = "XOR($A $B)(C<>) XOR[(A<> B<>)($C) $A$B():00[0] 01[1] 10[1] 11[0]]"
    expr = Circuit.expression(circuit_str)
    assert Circuit.invocation_names(expr) == ["XOR"]
  end
end
