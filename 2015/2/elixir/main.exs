defmodule Main do
  {_, input} =
    File.read("../input.txt")

  input =
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn v ->
      v |> String.split("x") |> Enum.map(fn v -> String.to_integer(v) end)
    end)

  input
  |> Enum.reduce(0, fn v, acc ->
    [l, w, h] = v
    sides = [l * w, w * h, h * l]
    acc + Enum.sum(sides) * 2 + Enum.min(sides)
  end)
  |> IO.puts()

  input
  |> Enum.reduce(0, fn measure, acc ->
    [l, w, h] = measure
    half_perimeter = [l + w, w + h, h + l]

    acc + Enum.reduce(measure, fn a, b -> a * b end) +
      Enum.min(half_perimeter) * 2
  end)
  |> IO.puts()
end
