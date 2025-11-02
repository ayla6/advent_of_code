import gleam/int.{to_string}
import gleam/io.{println}
import gleam/list.{Continue, Stop, fold, fold_until}
import gleam/result.{unwrap}
import gleam/string.{split, trim}
import simplifile.{read}

pub type FloorIndex {
  FloorIndex(floor: Int, index: Int)
}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim() |> split("")

  // part 1 - get final floor
  println(
    fold(input, 0, fn(fl, cur) {
      case cur {
        "(" -> fl + 1
        ")" -> fl - 1
        ___ -> 0
      }
    })
    |> to_string,
  )

  // part 2 - get first time in the basement
  println(
    {
      input
      |> fold_until(FloorIndex(0, 1), fn(fi, cur) {
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
    }.index
    |> to_string,
  )
}
