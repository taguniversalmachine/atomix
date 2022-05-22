defmodule Atomix.Invocation.Parser do
  import NimbleParsec

  name =
    ascii_string([?A..?Z, ?a..?z, ?_], min: 1)
    |> unwrap_and_tag(:name)

  constant_name =
    ascii_string([?A..?Z, ?a..?z, ?0..?9], min: 1)
    |> unwrap_and_tag(:constant_name)

  constant_content =
    ascii_string([?A..?Z, ?a..?z, ?0..?9], min: 1)
    |> unwrap_and_tag(:constant_content)

  constant_definition =
    constant_name
    |> ignore(string("["))
    |> concat(constant_content)
    |> ignore(string("]"))

  constant_definitions =
    repeat(
      ignore(repeat(string(" ")))
      |> concat(constant_definition)
      |> ignore(repeat(string(" ")))
    )
    |> tag(:constant_definitions)

  definition_name =
    ascii_string([?A..?Z, ?a..?z, ?_], min: 1)
    |> unwrap_and_tag(:definition_name)

  invocation_name =
    ascii_string([?A..?Z, ?a..?z, ?_], min: 1)
    |> unwrap_and_tag(:invocation_name)

  content_name =
    ascii_string([?A..?Z, ?a..?z], min: 1)
    |> unwrap_and_tag(:content_name)

  destination_place =
    ignore(string("$"))
    |> concat(name)
    |> unwrap_and_tag(:destination_place)

  destination_list =
    destination_place
    |> repeat(destination_place)
    |> tag(:destination_list)

  source_place =
    name
    |> ignore(string("<>"))
    |> tag(:source_place)

  source_list =
    source_place
    |> repeat(source_place)
    |> tag(:source_list)

  place_of_resolution =
    string("+")
    |> unwrap_and_tag(:place_of_resolution)

  defparsec(
    :invocation,
    invocation_name
    |> ignore(string("("))
    |> concat(destination_list)
    |> ignore(string(")"))
    |> ignore(string("("))
    |> concat(source_list)
    |> ignore(string(")"))
  )

  defparsec(
    :conditional_invocation_name,
    destination_list
    |> ignore(string("("))
    |> ignore(string(")"))
    |> tag(:conditional_invocation)
  )

  defparsec(
    :definition,
    definition_name
    |> ignore(string("["))
    |> ignore(string("("))
    |> concat(source_list)
    |> ignore(string(")"))
    |> ignore(string("("))
    |> concat(destination_list)
    |> ignore(string(")"))
    |> ignore(repeat(string(" ")))
    |> concat(place_of_resolution)
    |> ignore(repeat(string(" ")))
    |> ignore(string(":"))
    |> ignore(repeat(string(" ")))
    |> concat(constant_definitions)
    |> ignore(string("]"))
  )
end
