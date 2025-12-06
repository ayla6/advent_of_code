import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input = input |> string.trim
  let input =
    list.fold(list.range(1, 10), input, fn(acc, _) {
      acc |> string.replace("  ", " ")
    })
  let part_1 =
    input
    |> string.split("\n")
    |> list.map(fn(i) { string.split(i, " ") })
    |> list.transpose
    |> list.map(fn(i) {
      let i = list.reverse(i)
      let assert Ok(s) = list.first(i)
      let i =
        list.drop(i, 1) |> list.map(fn(i) { int.parse(i) |> result.unwrap(0) })
      let r = case s {
        "+" -> int.sum(i)
        "*" -> list.reduce(i, int.multiply) |> result.unwrap(0)
        _ -> panic as "invalid"
      }
      r
    })
    |> int.sum
  echo part_1
}
