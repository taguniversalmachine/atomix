defmodule ID3Test do
  use ExUnit.Case
  alias Atomix.Format.ID3
  @test_file "Hoàng Read  The Magic Bomb Questions I get asked Official Audio.mp3"

  @tag :skip
  test "open MP3 file" do
    path = Path.absname("test/format_test/#{@test_file}")
    mp3_bits = Atomix.Format.MP3.open(path)

    <<73, 68, 51, 4, 0, 0, 0, 0, 1, 0, 84, 88, 88, 88, x::binary>> = mp3_bits
  end
end
