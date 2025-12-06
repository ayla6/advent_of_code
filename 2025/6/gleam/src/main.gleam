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

type Align {
  Left
  Right
}

type Operation {
  Sum
  Mul
}

type Part2Line {
  Part2Line(align: Align, op: Operation, numbers: List(String))
}

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

  let lines =
    input
    |> string.split("\n")
    |> list.reverse
  let assert Ok(last_line) = list.first(lines)
  let #(_, bounds) =
    { last_line <> "                         *" }
    |> string.to_graphemes
    |> list.index_fold(#(0, list.new()), fn(acc, char, i) {
      let #(bound_start, bounds) = acc
      case char {
        "*" | "+" if i > 0 -> #(i, list.append([#(bound_start, i - 1)], bounds))
        _ -> acc
      }
    })
  let input_pt_2 =
    bounds
    |> list.index_fold(dict.new(), fn(d, bound, i) {
      let numbers =
        list.map(lines, fn(line) {
          string.slice(line, bound.0, bound.1 - bound.0)
        })
      let align =
        numbers
        |> list.drop(1)
        |> list.fold_until(Left, fn(res, number) {
          case
            string.trim(number) == number,
            string.trim_start(number) == number
          {
            True, _ -> list.Continue(res)
            _, True -> list.Stop(Left)
            _, _ -> list.Stop(Right)
          }
        })
      let assert Ok(sign) = list.first(numbers)
      let sign = case string.trim(sign) {
        "*" -> Mul
        "+" -> Sum
        _ -> panic as sign
      }
      dict.insert(
        d,
        i,
        Part2Line(
          align,
          sign,
          numbers |> list.drop(1) |> list.map(string.trim) |> list.reverse,
        ),
      )
    })
  let part_2 =
    input_pt_2
    |> dict.to_list
    |> list.map(fn(i) { i.1 })
    |> list.map(fn(line) {
      let d: Part2Dict = dict.new()
      let d =
        line.numbers
        |> list.fold(d, fn(d, number) {
          let number_len = string.length(number)
          string.to_graphemes(number)
          |> list.index_fold(d, fn(d, digit, index) {
            let assert Ok(digit) = digit |> int.parse
            let pos = case line.align {
              Right -> number_len - index
              Left -> index
            }
            dict.insert(
              d,
              pos,
              { dict.get(d, pos) |> result.unwrap(0) } * 10 + digit,
            )
          })
        })
      echo #(d, line)
      let numbers =
        dict.to_list(d)
        |> list.map(fn(n) { n.1 })

      let r = case line.op {
        Sum -> int.sum(numbers)
        Mul -> list.reduce(numbers, int.multiply) |> result.unwrap(0)
      }
      r
    })
    |> int.sum
  echo part_2
}
