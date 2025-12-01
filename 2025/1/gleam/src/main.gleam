import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub type RotationState {
  RotationState(number: Int, zeroes: Int)
}

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(l) {
      case l {
        "R" <> turn -> turn |> int.parse |> result.unwrap(0)
        "L" <> turn -> 0 - { turn |> int.parse |> result.unwrap(0) }
        _ -> panic as "bad input"
      }
    })

  let part1 =
    input
    |> list.fold(RotationState(50, 0), fn(acc, v) {
      let new_number =
        int.modulo(acc.number + v, 100)
        |> result.unwrap(0)
      RotationState(new_number, case new_number {
        0 -> acc.zeroes + 1
        _ -> acc.zeroes
      })
    })
  part1.zeroes
  |> int.to_string
  |> io.println

  let part2 =
    input
    |> list.fold(RotationState(50, 0), fn(acc, v) {
      let raw_new_number = acc.number + v
      let new_number = int.modulo(raw_new_number, 100) |> result.unwrap(0)
      let times_it_went_zero = {
        let value = int.absolute_value(raw_new_number / 100)
        case acc.number != 0, raw_new_number > 0 {
          True, False -> value + 1
          _, _ -> value
        }
      }
      RotationState(new_number, acc.zeroes + times_it_went_zero)
    })

  part2.zeroes
  |> int.to_string
  |> io.println
}
