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
    smallest = sides |> Enum.reduce(fn a, b -> min(a, b) end)
    (sides |> Enum.sum()) * 2 + smallest + acc
  end)
  |> IO.puts()

  input
  |> Enum.reduce(0, fn v, acc ->
    [l, w, h] = v
    half_perimeter = [l + w, w + h, h + l]
    smallest_half_perimeter = half_perimeter |> Enum.reduce(fn a, b -> min(a, b) end)
    l * w * h + smallest_half_perimeter * 2 + acc
  end)
  |> IO.puts()
end
