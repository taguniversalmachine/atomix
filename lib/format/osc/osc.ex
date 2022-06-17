defmodule Atomix.Format.OSC do
  import NimbleParsec

  osc_integer =
    ignore(string("i"))
    |> tag(:osc_integer)

  osc_float =
    ignore(string("f"))
    |> tag(:osc_float)

  osc_string =
    ignore(string("s"))
    |> tag(:osc_string)

  osc_blob =
    ignore(string("b"))
    |> tag(:osc_blob)

  osc_true =
    ignore(string("t"))
    |> tag(:osc_true)

  osc_false =
    ignore(string("f"))
    |> tag(:osc_false)

  osc_null =
    ignore(string("M"))
    |> tag(:osc_null)

  osc_infinitum =
    ignore(string("I"))
    |> tag(:osc_infinitum)

  osc_time_tag =
    ignore(string("t"))
    |> tag(:time_tag)

  osc =
    times(
      choice([
        osc_integer,
        osc_float,
        osc_string,
        osc_blob,
        osc_true,
        osc_false,
        osc_null,
        osc_infinitum,
        osc_time_tag
      ]),
      min: 1
    )
    |> tag(:osc)

  defparsec(:osc, osc)
end
