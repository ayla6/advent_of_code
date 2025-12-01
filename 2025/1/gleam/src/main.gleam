import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub type Direction {
  Left
  Right
}

pub type InputEntry {
  InputEntry(direction: Direction, turn: Int)
}

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
      let #(direction, turn) = case l {
        "R" <> turn -> #(Right, turn)
        "L" <> turn -> #(Left, turn)
        _ -> panic as "bad input"
      }
      InputEntry(direction, turn |> int.parse |> result.unwrap(0))
    })

  let part1 =
    input
    |> list.fold(RotationState(50, 0), fn(acc, v) {
      let new_number =
        int.modulo(
          acc.number
            + case v.direction {
            Right -> v.turn
            Left -> -v.turn
          },
          100,
        )
        |> result.unwrap(0)
      RotationState(
        new_number,
        acc.zeroes
          + case new_number {
          0 -> 1
          _ -> 0
        },
      )
    })

  part1.zeroes
  |> int.to_string
  |> io.println

  let part2 =
    input
    |> list.fold(RotationState(50, 0), fn(acc, v) {
      let raw_new_number =
        acc.number
        + case v.direction {
          Right -> v.turn
          Left -> -v.turn
        }
      // took too long to remember that abs isn't this im so fucking stupid
      let new_number = int.modulo(raw_new_number, 100) |> result.unwrap(0)
      // dumbest fuck in the world??? theres gotta be a mathy way of doing this
      let times_it_went_zero =
        list.range(acc.number, raw_new_number)
        |> list.fold(0, fn(acc2, i) {
          case i % 100 {
            0 if i != acc.number -> acc2 + 1
            _ -> acc2
          }
        })
      RotationState(new_number, acc.zeroes + times_it_went_zero)
    })

  part2.zeroes
  |> int.to_string
  |> io.println
}
