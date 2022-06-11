defmodule DPDTest do
  use ExUnit.Case
  import Atomix.Format.BitsSigil
  alias Atomix.Format.DPD
  require Logger

  test "Encodes 0..7" do
    assert Enum.map(0..7, fn x -> DPD.encode(x) end) == [
             ~b(0),
             ~b(1),
             ~b(10),
             ~b(11),
             ~b(100),
             ~b(101),
             ~b(110),
             ~b(111)
           ]
  end

  test "Encodes 3 small digits" do
    digits =
      for a <- 0..7, b <- 0..7, c <- 0..7 do
        Integer.undigits([a, b, c])
      end

    encoded_digits = Enum.map(digits, &Atomix.Format.DPD.encode/1)
    Logger.info("Encoded digits: #{inspect(encoded_digits)}")
    decoded_digits = Enum.map(encoded_digits, &Atomix.Format.DPD.decode/1)
  end
end
