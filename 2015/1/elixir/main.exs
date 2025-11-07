defmodule Main do
  {_, input} =
    File.read("../input.txt")

  input = input |> String.trim() |> String.graphemes()

  input
  |> Enum.reduce(0, fn step, floor ->
    case step do
      "(" -> floor + 1
      ")" -> floor - 1
    end
  end)
  |> IO.puts()

  input
  |> Enum.reduce_while({0, 0}, fn step, floor ->
    i = elem(floor, 0) + 1

    floor =
      elem(floor, 1) +
        case step do
          "(" -> 1
          ")" -> -1
        end

    case floor do
      -1 -> {:halt, {i, floor}}
      _ -> {:cont, {i, floor}}
    end
  end)
  |> elem(0)
  |> IO.puts()
end
