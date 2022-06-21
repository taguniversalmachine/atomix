defmodule Mix.Tasks.Atomix.Build do
  use Mix.Task
  require Logger

  @table_images [
    "docsource/hardware.esp32/devkitC/HeaderJ1/HeaderJ1.png",
    "docsource/hardware.esp32/devkitC/HeaderJ2/HeaderJ2.png",
    "docsource/hardware.esp32/4.9 Peripheral Signal List/4.9 Peripheral Signal List.png"
  ]

  @impl Mix.Task
  def run(args) do
    invocation_path = Path.absname("lib/invocation/*.inv")
    Logger.info("Looking for invocation files in #{inspect(invocation_path)}")

    invocations =
      case File.ls(invocation_path) do
        {:ok, invocations} ->
          Logger.info("Building #{inspect(Enum.count(invocations))}")
          invocations

        {:error, :enoent} ->
          Logger.info("No invocation files found")
          []
      end

    Logger.info("Built #{Enum.count(invocations)} invocations.")
  end

  def _extract(_args) do
    IO.puts("Build")
    {:ok, textract} = GenServer.start_link(Atomix.Textract, [])

    results =
      Enum.map(@table_images, fn image ->
        table_image = File.read!(image)
        result = GenServer.call(textract, {:analyze, table_image})
      end)

    IO.puts("Results")
    IO.inspect(results)
  end
end
