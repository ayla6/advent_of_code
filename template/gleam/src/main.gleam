import gleam/int
import gleam/io
import gleam/string
import simplifile as file

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input = input |> string.trim

  5
  |> int.to_string
  |> io.println
}
