import gleam/int.{to_string}
import gleam/io.{println}
import gleam/result.{unwrap}
import gleam/string.{trim}
import simplifile.{read}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim()

  println(
    5
    |> to_string,
  )
}
