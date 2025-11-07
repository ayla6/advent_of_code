import gleam/int
import gleam/io
import gleam/list.{Continue, Stop, fold}
import gleam/string
import simplifile as file

pub type FloorIndex {
  FloorIndex(floor: Int, index: Int)
}

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
  let input = input |> string.trim() |> string.split("")

  input
  |> fold(0, fn(fl, cur) {
    case cur {
      "(" -> fl + 1
      ")" -> fl - 1
      ___ -> 0
    }
  })
  |> int.to_string
  |> io.println

  // part 2 - get first time in the basement
  let FloorIndex(_, index) =
    input
    |> list.fold_until(FloorIndex(0, 1), fn(fi, cur) {
      let new = case cur {
        "(" -> fi.floor + 1
        ")" -> fi.floor - 1
        ___ -> 0
      }
      case new < 0 {
        True -> Stop(FloorIndex(new, fi.index))
        False -> Continue(FloorIndex(new, fi.index + 1))
      }
    })

  index
  |> int.to_string
  |> io.println
}
