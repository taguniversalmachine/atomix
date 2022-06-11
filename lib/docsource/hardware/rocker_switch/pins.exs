defmodule Atomix.Hardware.RockerSwitch do
  def init(_args) do
    %{pins: [:JWM, :JWL]}
  end
end
