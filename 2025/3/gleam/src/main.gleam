import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub fn do(input, digits) {
  input
  |> list.fold(0, fn(acc, bank) {
    let #(n, _) =
      list.range(digits - 1, 0)
      |> list.fold(#(0, bank), fn(acc, i) {
        let #(number, bank) = acc

        let max =
          bank
          |> list.reverse
          |> list.drop(i)
          |> list.reverse
          |> list.max(int.compare)
          |> result.unwrap(
            bank |> list.reverse |> list.first |> result.unwrap(0),
          )

        let max_loc =
          bank
          |> list.index_map(fn(n, i) { #(n, i) })
          |> list.key_find(max)
          |> result.unwrap(0)

        #(number * 10 + max, list.drop(bank, max_loc + 1))
      })
    acc + n
  })
}

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(bank) {
      string.to_graphemes(bank)
      |> list.map(fn(s) { int.parse(s) |> result.unwrap(0) })
    })

  do(input, 2)
  |> int.to_string
  |> io.println

  do(input, 12)
  |> int.to_string
  |> io.println
}
