import gleam/bit_array
import gleam/crypto.{Md5, hash}
import gleam/int.{to_string}
import gleam/io.{println}
import gleam/result.{unwrap}
import gleam/string.{trim}
import gleam/yielder.{Next, find, unfold}
import simplifile.{read}

// claude just helped me with understanding how yield works. didn't want to add that 1 manually because it's ugly. here's my pure mine attempt
//  let res =
//  yielder.unfold(0, fn(v) {
//    let hash =
//      crypto.hash(Md5, <<{ input <> to_string(v) }:utf8>>)
//      |> bit_array.base16_encode
//
//    case hash {
//      "00000" <> _ -> yielder.Done
//      ______ -> yielder.Next(v, v + 1)
//    }
//  })
//  |> yielder.last()
//  |> unwrap(0)
//  |> int.add(1)
//  |> to_string

pub fn find_first_with_leading(input: String, leading: String) {
  unfold(0, fn(v) { Next(v, v + 1) })
  |> find(fn(v) {
    hash(Md5, <<{ input <> to_string(v) }:utf8>>)
    |> bit_array.base16_encode
    |> string.starts_with(leading)
  })
  |> unwrap(0)
  |> to_string
}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim()
  println(find_first_with_leading(input, "00000"))
  println(find_first_with_leading(input, "000000"))
}
