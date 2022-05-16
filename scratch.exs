fb = fn (0,0,_) -> "FizzBuzz"
           (_,0,_) -> "Fizz"
(_,_,c) -> c
end

fc = fn n ->
  fb.(rem(n,3), rem(n,5), n)
end

result = for x <- 1..7 do
  fc.(x+9)
end

IO.inspect result

prefix = fn (first) -> (fn other -> "#{first} #{other}" end) end

mrs = prefix.("Mrs")

IO.inspect mrs.("Smith")

IO.inspect prefix.("Elixir").("Rocks")

defmodule MyList do
  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail)

  def square([]), do: []
  def square([head | tail]), do: [head * head | square(tail)]

  def add_1([]), do: []
  def add_1([head | tail]), do: [head + 1 | add_1(tail)]

  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]
end

defmodule CountDown do
  def sleep(seconds) do
    receive do
      after seconds*1000 -> nil
    end
  end

  def start_fun() do
    fn -> 0 end
  end

  def say(text) do
    spawn fn -> :os.cmd('say #{text}') end
  end

  def timer() do
    Stream.resource(
      fn -> # the number of seconds to start of next minute
        {_h, _m, s} = :erlang.time
        60 - s - 1
      end,
      fn # wait for the next second, then return its cowuntdown
        0 -> {:halt, 0}
        count -> sleep(1)
              {[inspect(count)], count - 1}
      end,
      fn _ -> nil end
    )
  end

  def next_fun(acc) do
     if true do
       {3, acc}
       else
       {:halt, acc}
     end
  end

  def after_fun(acc) do
    :ok
  end

  def count(seconds) do

  end
end
