import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub type RotationState {
  RotationState(turn: Int, zeroes: Int)
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
        "L" <> turn -> -{ turn |> int.parse |> result.unwrap(0) }
        _ -> panic as "bad input"
      }
    })

  let part1 =
    input
    |> list.fold(RotationState(50, 0), fn(acc, v) {
      let new_number =
        int.modulo(acc.turn + v, 100)
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
      let raw_new_number = acc.turn + v
      let raw_zeroes = int.absolute_value(raw_new_number / 100)
      let zeroes =
        acc.zeroes
        + case acc.turn != 0 && raw_new_number <= 0 {
          // if it is below zero before being moduloed and the original number itself wasn't zero it means that it did touch zero but the division thing wouldn't count it, so we give this extra support.
          // of course, there is no need to deal with a negative to positive situation because the acc.turn will never be negative!!!
          True -> raw_zeroes + 1
          False -> raw_zeroes
        }
      RotationState(int.modulo(raw_new_number, 100) |> result.unwrap(0), zeroes)
    })
  part2.zeroes
  |> int.to_string
  |> io.println
}
