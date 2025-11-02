import gleam/bit_array
import gleam/crypto.{Md5, hash}
import gleam/int.{to_string}
import gleam/io.{println}
import gleam/result.{unwrap}
import gleam/string.{trim}
import simplifile.{read}

pub fn find_first_with_leading(input: String, leading: String, i: Int) {
  let result =
    hash(Md5, <<{ input <> to_string(i) }:utf8>>)
    |> bit_array.base16_encode
    |> string.starts_with(leading)
  case result {
    True -> i
    False -> find_first_with_leading(input, leading, i + 1)
  }
}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim()
  println(find_first_with_leading(input, "00000", 0) |> to_string)
  println(find_first_with_leading(input, "000000", 0) |> to_string)
}
