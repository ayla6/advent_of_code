import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub fn main() {
  let assert Ok(right_sue) = file.read(from: "../sue.txt")
    as "Sue file not found"
  let right_sue =
    right_sue
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(i) {
      case string.split(i, " ") {
        [item, amount] -> #(
          string.drop_end(item, 1),
          int.parse(amount) |> result.unwrap(0),
        )
        _ -> #("", 0)
      }
    })
    |> dict.from_list

  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(i) {
      case string.split(i, " ") {
        [_, n, item1, amount1, item2, amount2, item3, amount3] -> #(
          string.drop_end(n, 1) |> int.parse |> result.unwrap(0),
          [
            #(
              string.drop_end(item1, 1),
              string.drop_end(amount1, 1) |> int.parse |> result.unwrap(0),
            ),
            #(
              string.drop_end(item2, 1),
              string.drop_end(amount2, 1) |> int.parse |> result.unwrap(0),
            ),
            #(
              string.drop_end(item3, 1),
              amount3 |> int.parse |> result.unwrap(0),
            ),
          ],
        )
        _ -> #(0, [#("", 0), #("", 0), #("", 0)])
      }
    })
    |> dict.from_list

  // part 1
  input
  |> dict.fold(0, fn(right, sue, items) {
    let total_right =
      items
      |> list.fold_until(0, fn(total_right, item) {
        case item.1 == dict.get(right_sue, item.0) |> result.unwrap(-10) {
          True -> list.Continue(total_right + 1)
          False -> list.Stop(total_right)
        }
      })
    case total_right {
      3 -> sue
      _ -> right
    }
  })
  |> int.to_string
  |> io.println

  // part 2
  input
  |> dict.fold(0, fn(right, sue, items) {
    let total_right =
      items
      |> list.fold_until(0, fn(total_right, item) {
        let right_value = dict.get(right_sue, item.0) |> result.unwrap(-10)
        let comp = case item.0 {
          "cats" | "trees" -> item.1 > right_value
          "pomeranians" | "goldfish" -> item.1 < right_value
          _ -> item.1 == right_value
        }
        case comp {
          True -> list.Continue(total_right + 1)
          False -> list.Stop(total_right)
        }
      })
    case total_right {
      3 -> sue
      _ -> right
    }
  })
  |> int.to_string
  |> io.println
}
