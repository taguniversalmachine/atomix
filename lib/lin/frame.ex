defmodule Atomix.Lin.Frame do
  defstruct do
    [:break, :sync, :ID]
  end

  def header(id) do
    # break-sync-id sequence
    break = <<0::8>>
    sync = <<0::8>>
    id = id
    <<break::binary>> <> <<sync::binary>> <> <<id::binary>>
  end

end
