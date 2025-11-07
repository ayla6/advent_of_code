import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub fn main() {
  let input =
    file.read(from: "../input.txt")
    |> result.unwrap("")
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(str) {
      string.split(str, "x")
      |> list.map(fn(str) { int.base_parse(str, 10) |> result.unwrap(0) })
    })

  // part 1
  input
  |> list.fold(0, fn(prev, cur) {
    let sides =
      cur
      |> list.combinations(2)
      |> list.map(fn(v) { list.fold(v, 1, int.multiply) })

    prev
    + list.fold(sides, 0, fn(prev, cur) { prev + 2 * cur })
    + { list.reduce(sides, int.min) |> result.unwrap(0) }
  })
  |> int.to_string
  |> io.println

  // part 2
  input
  |> list.fold(0, fn(prev, cur) {
    let smallest_perimeter =
      list.reduce(
        cur
          |> list.map(fn(v) { v |> int.multiply(2) })
          |> list.combinations(2)
          |> list.map(fn(v) { list.fold(v, 0, int.add) }),
        int.min,
      )
      |> result.unwrap(0)

    prev + smallest_perimeter + list.fold(cur, 1, int.multiply)
  })
  |> int.to_string
  |> io.println
}
