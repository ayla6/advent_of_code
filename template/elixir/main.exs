defmodule Main do
  {_, input} =
    File.read("../input.txt")

  input = input |> String.trim()

  IO.puts(input)
end
