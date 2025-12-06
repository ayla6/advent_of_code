import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import simplifile as file

type Part2Dict =
  dict.Dict(Int, Int)

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input = input |> string.trim
  let input_pt_1 =
    list.fold(list.range(1, 10), input, fn(acc, _) {
      acc |> string.replace("  ", " ")
    })

  let part_1 =
    input_pt_1
    |> string.split("\n")
    |> list.map(fn(i) { string.trim(i) |> string.split(" ") })
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

  let assert Ok(regex) = regexp.from_string("   *")
  let input_pt_2 = regexp.replace(regex, input, "X ")

  echo input_pt_2
    |> string.split("\n")
    |> list.map(fn(i) { string.trim(i) |> string.split(" ") })
    |> list.transpose

  let part_2 =
    input_pt_2
    |> string.split("\n")
    |> list.map(fn(i) { string.trim(i) |> string.split(" ") })
    |> list.transpose
    |> list.index_map(fn(ninput, col) {
      let i = list.reverse(ninput)
      let assert Ok(s) = list.first(i)
      let i = list.drop(i, 1)
      let i = list.reverse(i)
      let d: Part2Dict = dict.new()
      let d =
        i
        |> list.fold(d, fn(d, number) {
          let number_len = string.length(number)
          string.to_graphemes(number)
          |> list.index_fold(d, fn(d, digit, index) {
            let assert Ok(digit) = digit |> int.parse
            let pos = case col % 2 {
              0 -> number_len - index
              _ -> index
            }
            dict.insert(
              d,
              pos,
              { dict.get(d, pos) |> result.unwrap(0) } * 10 + digit,
            )
          })
        })
      let numbers =
        dict.to_list(d)
        |> list.map(fn(n) { n.1 })

      let r = case s {
        "+" -> int.sum(numbers)
        "*" -> list.reduce(numbers, int.multiply) |> result.unwrap(0)
        _ -> panic as "invalid"
      }
      r
    })
    |> int.sum
  echo part_2
}
