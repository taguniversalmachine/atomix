#
# This file is part of AtomVM.
#
# Copyright 2022 TAG Universal Machine <taguniversalmachine@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0 OR LGPL-2.1-or-later
#
defmodule Atomix.Format.DPD do
  import Atomix.Format.BitsSigil
  import Logger
  alias MakeBits, as: B
  # Densely packed decimal

  def encode(0) do
    ~b(0)
  end

  def encode(1) do
    ~b(1)
  end

  def encode(2) do
    ~b(10)
  end

  def encode(3) do
    ~b(11)
  end

  def encode(4) do
    ~b(100)
  end

  def encode(5) do
    ~b(101)
  end

  def encode(6) do
    ~b(110)
  end

  def encode(7) do
    ~b(111)
  end

  def encode(8) do
    ~b(1000)
  end

  def encode(9) do
    ~b(1001)
  end

  def encode(other) do
    other
  end

  def small?(digit) do
    if digit <= 7, do: true, else: false
  end

  def large?(digit) do
    if digit > 7 and digit <= 9, do: true, else: false
  end

  def encode(digits) do
    digits_list = Integer.digits(digits)
    Logger.info("Encoding #{digits_list}")
    # Pad with 0 to make 3 digits
    digits_list =
      cond do
        Enum.count(digits_list) == 3 ->
          digits_list

        Enum.count(digits_list) == 2 ->
          [0] ++ digits_list

        Enum.count(digits_list) == 1 ->
          [0, 0] ++ digits_list
          # Two small digits, one large
      end

    [d2, d1, d0] = digits_list
    Logger.info("Encode d2:#{d2} d1:#{d1} d0:#{d0}")
    binary_string = Integer.to_string(Integer.undigits(digits_list), 2)
    bitstring = B.string_to_bitstring(binary_string)
    #  bitstring = MakeBits.append_ascii(binary_charlist)
    #  IO.inspect bitstring
    cond do
      small?(d2) && small?(d1) && small?(d0) ->
        # return all the bits unchanged except for b3 which is set to 0
        <<B.b9(bitstring), B.b8(bitstring), B.b7(bitstring), B.b6(bitstring), B.b5(bitstring),
          B.b4(bitstring), 0, B.b2(bitstring), B.b1(bitstring, B.b0(bitstring))>>

      # something
      small?(d2) && small?(d1) && large?(d0) ->
        2

      # something
      small?(d2) && large?(d1) && small?(d0) ->
        3

      # something
      large?(d2) && small?(d1) && small?(d0) ->
        4
    end
  end

  def encode_digits(a, b, c) do
    a_bits = decimal_to_binary(a)
    b_bits = decimal_to_binary(b)
    c_bits = decimal_to_binary(c)

    #  incoming = <<bit_a(a_bits), bit_b(bits), bit_c(bits), bit_d(bits), bit_e(bits), bit_f(bits), bit_g(bits), bit_h(bits), bit_i(bits)>>
    #  incoming
    0
  end

  def decode(<<a::1, b::1, c::1, d::1, e::1, f::1, 0, h::1, i::1>>) do
    # Three small digits
    <<a, b, c, d, e, f, 0, h, i>>
    {<<0, a, b, c>>, <<0, d, e, f>>, <<0, 0, h, i>>}
  end

  def decode(
        <<a::integer()-size(1), b::integer()-size(1), c::integer()-size(1), d::integer()-size(1),
          e::integer()-size(1), f::integer()-size(1), 0, h::integer()-size(1),
          i::integer()-size(1)>>
      ) do
    Logger.info("Decoding ?")
  end

  def decode(other) do
    # Logger.info("Unhandled decoding #{inspect(other)}")
    other
  end

  def decimal_to_binary(decimal_str) when is_binary(decimal_str) do
    decimal_str
    |> String.to_integer()
    |> decimal_to_binary()
    |> String.trim()
  end

  def decimal_to_binary(num) when is_integer(num) do
    binary_str = String.pad_leading(List.to_string(:io_lib.format("~.2B", [num])), 9, "0")
    ~b(binary_str)
  end
end

defmodule MakeBits do
  def append_ascii(ascii_bitstring, [ascii_bit]) do
    bitstring = for <<cp <- ascii_bitstring>>, do: <<char2bit(cp)::1>>, into: <<>>
    <<bitstring::bitstring, char2bit(ascii_bit)::1>>
  end

  def string_to_bitstring(ascii_bitstring) do
    for <<cp <- ascii_bitstring>>, do: <<char2bit(cp)::1>>, into: <<>>
  end

  def labeled_bits(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    %{:a => a, :b => b, :c => c, :d => d, :e => e, :f => f, :g => g, :h => h, :i => i}
  end

  def char2bit(?0), do: 0
  def char2bit(?1), do: 1

  def b0(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    a
  end

  def b1(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    b
  end

  def b2(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    c
  end

  def b3(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    c
  end

  def b4(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    d
  end

  def b5(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    e
  end

  def b6(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    f
  end

  def b7(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    g
  end

  def b8(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    h
  end

  def b9(bitstring) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1>> = bitstring
    i
  end

  def bit_a(digit) do
    <<>>
  end

  def bit_b(digit) do
    <<>>
  end

  def bit_c(digit) do
    <<>>
  end

  def bit_d(digit) do
    <<>>
  end

  def bit_e(digit) do
    <<>>
  end

  def bit_f(digit) do
    <<>>
  end

  def bit_g(digit) do
    <<>>
  end

  def bit_h(digit) do
    <<>>
  end

  def bit_i(digit) do
    <<>>
  end
end
