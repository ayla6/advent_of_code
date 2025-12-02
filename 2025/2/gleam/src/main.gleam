import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

type Range {
  Range(start: Int, end: Int)
}

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  // let input =
  //   "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
  let input =
    input
    |> string.trim
    |> string.split(",")
    |> list.map(fn(s) {
      case string.split(s, "-") {
        [start, end] ->
          Range(
            start |> int.parse |> result.unwrap(0),
            end |> int.parse |> result.unwrap(0),
          )
        _ -> panic as "invalid input"
      }
    })

  input
  |> list.fold(0, fn(acc, r) {
    list.range(r.start, r.end)
    |> list.fold(acc, fn(acc, i) {
      let s = int.to_string(i)
      let len = string.length(s)
      case string.slice(s, 0, len / 2) |> string.repeat(2) == s {
        True -> acc + i
        False -> acc
      }
    })
  })
  |> int.to_string
  |> io.println

  input
  |> list.fold(0, fn(acc, r) {
    list.range(r.start, r.end)
    |> list.fold(acc, fn(acc, i) {
      case i >= 10 {
        True -> {
          let s = int.to_string(i)
          let len = string.length(s)
          list.range(len / 2, 1)
          |> list.fold_until(acc, fn(acc, cur_len) {
            let n =
              string.slice(s, 0, cur_len)
              |> string.repeat(int.max(2, len / cur_len))
            case n == s {
              True -> list.Stop(acc + i)
              False -> list.Continue(acc)
            }
          })
        }
        False -> acc
      }
    })
  })
  |> int.to_string
  |> io.println
}
