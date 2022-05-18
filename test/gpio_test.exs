defmodule GPIOTest do
  use ExUnit.Case
  alias Atomix.Esp32.Core.GPIO.GPIO

  test "get by name" do
    assert GPIO.get_by_name(:GPIO_OUT1_REG)[:Address] == "0x3FF44010"
  end
end
