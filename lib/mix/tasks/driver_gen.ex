defmodule Mix.Tasks.Atomix.Gen.Driver do
  use Mix.Task
  require Logger

  @impl Mix.Task
  def run(args) do
    if args == [] do
    IO.puts "USAGE: mix atomix.gen.driver <driver1> <driver2> ..."
    exit(:shutdown)
    end
    module = Enum.at(args, 0)
    Logger.info("Generating driver for #{module}")
    {:ok, c_program} = Atomix.Hardware.NIFGen.generate(module)
    output_path = "_build/nif"
    if not File.exists?(output_path), do: File.mkdir!(output_path)
    nif_file = "#{output_path}/atomix_#{module}_nif.c"
    File.write!(nif_file, c_program)
    Logger.info("Generated #{nif_file}")
    {_result, 0} = System.cmd("gcc", ["-o", "#{module}_nif.so", "-fpic", "-shared", nif_file  ])
  end
end
