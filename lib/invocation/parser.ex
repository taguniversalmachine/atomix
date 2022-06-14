defmodule Atomix.Invocation.Parser do
  import NimbleParsec

  defparsec(
    :whitespace,
    times(
      choice([
        ignore(string(" ")),
        ignore(string("\u000D")),
        ignore(string("\u000A"))
      ]),
      min: 1
    )
    |> tag(:whitespace)
  )

  comma =
    ignore(string(","))
    |> tag(:comma)

  defparsec(:comma, comma)

  name =
    ascii_string([?A..?Z, ?a..?z, ?_, ?0..?9], min: 1)
    |> unwrap_and_tag(:name)

  defparsec(:name, name)

  source_place =
    name
    |> ignore(string("<>"))
    |> ignore(repeat(string(" ")))
    |> tag(:source_place)

  defparsec(:source_place, source_place)

  unnamed_source_place =
    ignore(string("<"))
    |> parsec(:invocation)
    |> ignore(string(">"))
    |> tag(:unnamed_source_place)

  defparsec(:unnamed_source_place, unnamed_source_place)

  unnamed_empty_source_place =
    ignore(string("<>"))
    |> tag(:unnamed_source_place)

  defparsec(:unnamed_empty_source_place, unnamed_empty_source_place)

  source_list =
    times(
      choice([
        source_place,
        unnamed_source_place,
        unnamed_empty_source_place,
        ignore(parsec(:whitespace)),
        ignore(parsec(:comma))
      ]),
      min: 0
    )
    |> tag(:source_list)

  defparsec(:source_list, source_list)

  source_list_parens =
    ignore(string("("))
    |> concat(source_list)
    |> ignore(string(")"))

  defparsec(:source_list_parens, source_list_parens)

  destination_place =
    ignore(string("$"))
    |> concat(name)
    |> unwrap_and_tag(:destination_place)

  defparsec(:destination_place, destination_place)

  destination_list =
    times(
      choice([
        destination_place,
        parsec(:invocation),
        parsec(:constant_content),
        #   parsec(:conditional_invocation),
        ignore(parsec(:whitespace)),
        ignore(parsec(:comma))
      ]),
      min: 1
    )
    |> tag(:destination_list)

  defparsec(:destination_list, destination_list)

  destination_list_parens =
    optional(ignore(parsec(:whitespace)))
    |> ignore(string("("))
    |> concat(destination_list)
    |> ignore(string(")"))
    |> optional(ignore(parsec(:whitespace)))

  defparsec(:destination_list_parens, destination_list_parens)

  constant_content =
    ascii_string([?0..?9, ?A..?Z], min: 1)
    |> unwrap_and_tag(:constant_content)

  defparsec(:constant_content, constant_content)

  constant_name =
    ascii_string([?A..?Z, ?a..?z, ?0..?9], min: 1)
    |> unwrap_and_tag(:constant_name)

  constant_definition =
    constant_name
    |> ignore(string("["))
    |> concat(constant_content)
    |> ignore(string("]"))

  constant_definitions =
    times(choice([constant_definition, ignore(parsec(:whitespace))]), min: 1)
    |> tag(:constant_definitions)

  defparsec(:constant_definitions, constant_definitions)

  definition_name =
    ascii_string([?A..?Z, ?a..?z, ?_], min: 1)
    |> optional(ascii_string([?A..?Z, ?a..?z, ?0..?9], min: 1))
    |> tag(:definition_name)

  defparsec(:definition_name, definition_name)

  invocation_name =
    ascii_string([?A..?Z, ?a..?z, ?_], min: 1)
    |> unwrap_and_tag(:invocation_name)

  conditional_invocation =
    times(parsec(:destination_place), min: 1)
    |> ignore(string("()"))
    |> tag(:conditional_invocation)

  defparsec(
    :conditional_invocation,
    conditional_invocation
  )

  unnamed_source_place_with_conditional_invocation =
    ignore(string("<"))
    |> concat(parsec(:conditional_invocation))
    |> ignore(string(">"))
    |> tag(:unnamed_source_place)

  defparsec(
    :unnamed_source_place_with_conditional_invocation,
    unnamed_source_place_with_conditional_invocation
  )

  mutually_exclusive_completeness =
    ignore(string("{"))
    |> concat(source_list)
    |> ignore(string("}"))
    |> tag(:mutually_exclusive_completeness)

  defparsec(:mutually_exclusive_completeness, mutually_exclusive_completeness)

  arbitration =
    ignore(string("{{"))
    |> concat(destination_list)
    |> ignore(string("}}"))
    |> tag(:arbitration)

  defparsec(
    :arbitration,
    arbitration
  )

  place_of_resolution =
    choice([
      times(conditional_invocation, min: 1),
      times(parsec(:invocation), min: 1),
      times(constant_definitions, min: 1),
      unnamed_source_place,
      ignore(parsec(:whitespace))
    ])
    |> debug()
    |> tag(:place_of_resolution)

  defparsec(:place_of_resolution, place_of_resolution)

  defparsec(
    :invocation,
    invocation_name
    |> ignore(string("("))
    |> times(choice([destination_list, parsec(:invocation)]), min: 1)
    |> ignore(string(")"))
    |> optional(
      ignore(string("("))
      |> parsec(:source_list)
      |> ignore(string(")"))
    )
    |> tag(:invocation)
  )

  definition =
    definition_name
    |> ignore(string("["))
    |> concat(source_list_parens)
    |> optional(destination_list_parens)
    |> choice([
      unnamed_source_place,
      conditional_invocation,
      arbitration,
      unnamed_source_place_with_conditional_invocation
    ])
    |> ignore(string(":"))
    |> concat(place_of_resolution)
    |> ignore(string("]"))
    |> tag(:definition)

  defparsec(
    :definition,
    definition
  )

  defparsec(
    :expression,
    times(choice([definition, parsec(:invocation), ignore(string(" "))]), min: 1, max: 3)
    |> tag(:expression)
  )

  peripherals_4_9 = string("")
  defparsec(:peripherals_4_9, peripherals_4_9)
end
