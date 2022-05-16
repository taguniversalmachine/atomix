defmodule Mix.Tasks.Build.Docs do
  use Mix.Task

  @table_images [
    "docsource/hardware.esp32/devkitC/HeaderJ1/HeaderJ1.png",
    "docsource/hardware.esp32/devkitC/HeaderJ2/HeaderJ2.png",
    "docsource/hardware.esp32/4.9 Peripheral Signal List/4.9 Peripheral Signal List.png"
  ]

  @impl Mix.Task
  def run(args) do
    IO.puts("BuildDocs")
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
