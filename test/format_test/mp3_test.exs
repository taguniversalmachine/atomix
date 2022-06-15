defmodule Atomix.Format.MP3Test do
  use ExUnit.Case
  require Atomix.Format.MP3

  @tag :skip
  test "opens MP3" do
    path = Path.absname("test/format_test/Minimal Techno Music (8D Bass Boosted).mp3")
    mp3 = Atomix.Format.MP3.open(path)
    <<73, 68, 51, 4, 0, 0, 0, 0, 70, 41, 84, 80, 69, 49, x::binary>> = mp3
  end
end
