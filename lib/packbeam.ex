defmodule Mix.Tasks.Atom.Packbeam do
  @moduledoc "Packs BEAM files into avm packbeam format`"
  @shortdoc "Pack BEAM files"

  use Mix.Task
  require Logger

  @impl Mix.Task
  def run(args) do
    compile_result = Mix.Tasks.Compile.Elixir.run(args)
    IO.inspect compile_result
    beam_files = get_beam_files()
    IO.inspect beam_files
    encoded_beam_files = Enum.map(beam_files, &encode_beam_file/1)
    concatenated_encoded_beam_files = Enum.reduce(encoded_beam_files, <<0::0>>, &Kernel.<>/2)
    avm = packbeam_header() <> concatenated_encoded_beam_files
    write_avm(avm)
    :ok
  end


  defp packbeam_header() do
    <<0x23, 0x21, 0x2f, 0x75,
      0x73, 0x72, 0x2f, 0x62,
      0x69, 0x6e, 0x2f, 0x65,
      0x6e, 0x76, 0x20, 0x41,
      0x74, 0x6f, 0x6d, 0x56,
      0x4d, 0x0a, 0x00, 0x00>>
  end

  defp get_beam_files() do
     config = Mix.Project.config()
     # _build/{ENV}/lib/{project_name}/ebin/*.beam
     project_name = Keyword.fetch!(config, :app)
     environment = Mix.env()
     directory = "./_build/#{environment}/lib/#{project_name}/ebin"
     directory_wildcard = "#{directory}/*.beam"
     beam_files = Path.wildcard(directory_wildcard) |> Enum.map(&Path.absname/1)
     beam_files
  end

  defp encode_beam_file(beam_file) do
    file_header = file_header(beam_file)
    {:ok, file_pid} = File.open(beam_file, [:read])
    Logger.info "Calling IO.read with #{inspect(file_pid)}"
    result = IO.read(file_pid, :all)
    result
  end

  defp write_avm(bytes) do
    environment = Mix.env()
    config = Mix.Project.config()
    project_name  = Keyword.fetch!(config, :app)
    directory = "./_build/#{environment}/lib/#{project_name}/ebin"
    file_name = "out.avm"
    absolute_path = "#{directory}/#{file_name}"
    Logger.info "write_avm Writing to #{absolute_path}"
    {:ok, output_file_pid} = File.open(absolute_path, [:write])
    result = IO.write(output_file_pid, bytes)
    result
  end

  @doc """
  File Header

  The file header consists of the following 4 fields:

  size (32 bit, big-endian)

  flags (32-bit, big endian)

  reserved (32-bit, big-endian, currently unused)

  module_name (null-terminated sequence of bytes)
"""
  def file_header(path) do
    size = <<0::32>>
    flags = <<0::32>>
    reserved = <<0::32>>
    module_name = Path.basename(path)
  end
end