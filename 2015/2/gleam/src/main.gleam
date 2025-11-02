import gleam/int.{add, min, multiply, to_string}
import gleam/io.{println}
import gleam/list.{combinations, fold, map, reduce}
import gleam/result.{unwrap}
import gleam/string.{split, trim}
import simplifile.{read}

pub fn main() {
  let input =
    read(from: "../input.txt")
    |> unwrap("")
    |> trim()
    |> split("\n")
    |> map(fn(str) {
      split(str, "x")
      |> map(fn(str) { int.base_parse(str, 10) |> unwrap(0) })
    })

  // part 1
  println(
    input
    |> fold(0, fn(prev, cur) {
      let sides =
        cur
        |> combinations(2)
        |> map(fn(v) { fold(v, 1, multiply) })

      prev
      + fold(sides, 0, fn(prev, cur) { prev + 2 * cur })
      + { reduce(sides, min) |> unwrap(0) }
    })
    |> to_string,
  )

  // part 2
  println(
    input
    |> fold(0, fn(prev, cur) {
      let smallest_perimeter =
        reduce(
          cur
            |> map(fn(v) { multiply(v, 2) })
            |> combinations(2)
            |> map(fn(v) { fold(v, 0, add) }),
          min,
        )
        |> unwrap(0)

      prev + smallest_perimeter + fold(cur, 1, multiply)
    })
    |> to_string,
  )
}
