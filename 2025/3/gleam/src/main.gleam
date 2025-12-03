import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

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

  input
  |> list.fold(0, fn(acc, bank) {
    let #(n, _) =
      list.range(2, 1)
      |> list.fold(#(0, bank), fn(acc, i) {
        let #(number, bank) = acc
        let bank_find =
          bank
          |> list.reverse
          |> list.drop(i - 1)
          |> list.reverse

        let max =
          bank_find
          |> list.max(int.compare)
          |> result.unwrap(list.last(bank) |> result.unwrap(0))

        let max_loc =
          bank
          |> list.index_map(fn(n, i) { #(n, i) })
          |> list.key_find(max)
          |> result.unwrap(0)
        #(
          number
            + max
            * float.round(
            int.power(10, int.to_float(i - 1)) |> result.unwrap(0.0),
          ),
          list.drop(bank, max_loc + 1),
        )
      })
    acc + n
  })
  |> int.to_string
  |> io.println

  input
  |> list.fold(0, fn(acc, bank) {
    let #(n, _) =
      list.range(12, 1)
      |> list.fold(#(0, bank), fn(acc, i) {
        let #(number, bank) = acc
        let bank_find =
          bank
          |> list.reverse
          |> list.drop(i - 1)
          |> list.reverse

        let max =
          bank_find
          |> list.max(int.compare)
          |> result.unwrap(list.last(bank) |> result.unwrap(0))

        let max_loc =
          bank
          |> list.index_map(fn(n, i) { #(n, i) })
          |> list.key_find(max)
          |> result.unwrap(0)
        #(
          number
            + max
            * float.round(
            int.power(10, int.to_float(i - 1)) |> result.unwrap(0.0),
          ),
          list.drop(bank, max_loc + 1),
        )
      })
    acc + n
  })
  |> int.to_string
  |> io.println
}
