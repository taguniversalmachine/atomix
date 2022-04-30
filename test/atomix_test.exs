defmodule AtomixTest do
  use ExUnit.Case
  doctest Atomix

  test "greets the world" do
    assert Atomix.hello() == :world
  end

  test "starts master task" do
    {:ok, master} = GenServer.start_link(Atomix.Lin.Master,%{})
    assert Process.alive?(master)
  end
end
