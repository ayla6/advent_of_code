import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile as file

type Results =
  Set(String)

type Combinations =
  Dict(String, Results)

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input = input |> string.trim |> string.split("\n") |> list.reverse
  let combinations: Combinations =
    input
    |> list.drop(2)
    |> list.map(fn(v) {
      case v |> string.split(" ") {
        [origin, _, result] -> #(origin, result)
        _ -> #("", "")
      }
    })
    |> list.fold(dict.new(), fn(acc, v) {
      acc
      |> dict.get(v.0)
      |> result.unwrap(set.new())
      |> set.insert(v.1)
      |> dict.insert(acc, v.0, _)
    })
  let molecule = {
    let molecule =
      input
      |> list.first
      |> result.unwrap("")
      |> string.to_graphemes
      |> list.fold(#(list.new(), ""), fn(acc, letter) {
        case letter == string.lowercase(letter) {
          True -> #(acc.0, acc.1 <> letter)
          False -> #(list.append(acc.0, [acc.1]), letter)
        }
      })
    molecule.0 |> list.drop(1) |> list.append([molecule.1])
  }
  let part_1_res = {
    list.range(1, list.length(molecule)) |> list.fold(set.new(), fn(acc, v) {
      
    })
  }
}
