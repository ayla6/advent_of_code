import gleam/result.{unwrap}
import gleam/string.{trim}
import simplifile.{read}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim()
  echo input
}
