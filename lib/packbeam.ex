defmodule Mix.Tasks.Atom.Packbeam do
  @moduledoc "Packs BEAM files into avm packbeam format`"
  @shortdoc "Pack BEAM files"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    compile_result = Mix.Tasks.Compile.Elixir.run(args)
    IO.inspect compile_result
    avm = packbeam_header() <> file_header()
    IO.inspect avm
  end

  defp packbeam_header() do
    <<0x23, 0x21, 0x2f, 0x75,
      0x73, 0x72, 0x2f, 0x62,
      0x69, 0x6e, 0x2f, 0x65,
      0x6e, 0x76, 0x20, 0x41,
      0x74, 0x6f, 0x6d, 0x56,
      0x4d, 0x0a, 0x00, 0x00>>
  end

  @doc """
  File Header

  The file header consists of the following 4 fields:

  size (32 bit, big-endian)

  flags (32-bit, big endian)

  reserved (32-bit, big-endian, currently unused)

  module_name (null-terminated sequence of bytes)
"""
  def file_header() do
    size = <<0::32>>
    flags = <<0::32>>
    reserved = <<0::32>>
    module_name = "test"
  end
end