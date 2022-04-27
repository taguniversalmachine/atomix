defmodule AtomixTest do
  use ExUnit.Case
  doctest Atomix

  test "greets the world" do
    assert Atomix.hello() == :world
  end
end
