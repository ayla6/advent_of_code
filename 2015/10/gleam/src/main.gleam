import gleam/int
import gleam/io.{println}
import gleam/list
import gleam/result.{unwrap}
import gleam/string.{trim}
import simplifile.{read}

fn look_and_say(input, output, last_char, last_char_count, i) {
  let char = string.slice(input, i, 1)
  case char == last_char {
    True -> look_and_say(input, output, char, last_char_count + 1, i + 1)
    False -> {
      let output = output <> int.to_string(last_char_count) <> last_char
      case char != "" {
        True -> look_and_say(input, output, char, 1, i + 1)
        False -> output
      }
    }
  }
}

fn look_and_say_helper(input) {
  let char = string.slice(input, 0, 1)
  look_and_say(input, "", char, 1, 1)
}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim()

  let res =
    list.range(1, 40)
    |> list.fold(input, fn(acc, i) {
      echo i
      look_and_say_helper(acc)
    })
  println(string.length(res) |> int.to_string)
}
