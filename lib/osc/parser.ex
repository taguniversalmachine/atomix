defmodule Atomix.OSC.Parser do
  import NimbleParsec

  # Atomic Data Types
  int32 = integer(10)
  osc_timetag = integer(20)
end
