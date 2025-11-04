import gleam/int.{to_string}
import gleam/io.{println}
import gleam/string
import simplifile.{read as read_file}

pub fn main() {
  let assert Ok(input) = read_file(from: "../input.txt")
    as "Input file not found"
  let input = input |> string.trim

  println(
    5
    |> to_string,
  )
}
