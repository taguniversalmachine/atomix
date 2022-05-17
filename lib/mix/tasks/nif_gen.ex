defmodule Mix.Tasks.NIF.Gen do
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    {header, c_program} = Atomix.Hardware.NIFGen.generate()
    output_path = "_build/nif"
    if not File.exists?(output_path), do: File.mkdir!(output_path)
    File.write!("#{output_path}/atomix_nif.h", header)
    File.write!("#{output_path}/atomix_nif.c", c_program)
  end


end
