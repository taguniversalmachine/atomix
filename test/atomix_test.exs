defmodule AtomixTest do
  use ExUnit.Case
  doctest Atomix
  require Logger

  test "greets the world" do
    assert Atomix.hello() == :world
  end

  test "starts master task" do
    {:ok, master} = GenServer.start_link(Atomix.Lin.Master, %{})
    assert Process.alive?(master)
  end

  test "reads doc" do
    peripherals = Atomix.Reader.get(:peripherals49)
    assert Enum.count(peripherals) == 197
  end
end
