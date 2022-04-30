defmodule Atomix.Lin.Slave do
  require Logger

  def poll(state) do
    receive do
      {:data, data} -> Logger.info("Slave received data")
    end
  end
end
