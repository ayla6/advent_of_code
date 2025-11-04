import gleam/bit_array
import gleam/int
import gleam/io.{println}
import gleam/list
import gleam/result.{unwrap}
import gleam/string.{trim}
import simplifile.{read}

fn look_and_say(
  input,
  output: List(BitArray),
  last_char: BitArray,
  last_char_count,
  i,
) {
  let char = bit_array.slice(input, i, 1)
  case char |> unwrap(<<>>) == last_char {
    True -> look_and_say(input, output, last_char, last_char_count + 1, i + 1)
    False -> {
      let output =
        output
        |> list.prepend(<<int.to_string(last_char_count):utf8>>)
        |> list.prepend(last_char)
      case char {
        Ok(char) -> look_and_say(input, output, char, 1, i + 1)
        Error(_) -> output
      }
    }
  }
}

fn look_and_say_helper(input) {
  let char = bit_array.slice(<<input:utf8>>, 0, 1) |> unwrap(<<>>)
  look_and_say(<<input:utf8>>, [], char, 1, 1)
  |> list.reverse
  |> bit_array.concat
  |> bit_array.to_string
  |> unwrap("")
}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim()

  let res =
    list.range(1, 50)
    |> list.fold(input, fn(acc, i) {
      case i == 41 {
        True -> println(string.length(acc) |> int.to_string)
        False -> Nil
      }
      look_and_say_helper(acc)
    })
  println(string.length(res) |> int.to_string)
}
