import gleam/io.{println}
import gleam/list
import gleam/result
import gleam/string.{trim}
import simplifile.{read}

fn has_three_letter_sequence(
  input input,
  iterator i,
  prev_letter_value prev_letter_value,
  line_length line_length,
) {
  let letter = string.slice(input, i, 1)
  case letter != "" {
    False -> False
    True -> {
      let assert [codepoint] = string.to_utf_codepoints(letter)
      let v = string.utf_codepoint_to_int(codepoint)
      let in_sequence = prev_letter_value == v - 1
      case in_sequence && line_length == 1 {
        False -> {
          let line_length = case in_sequence {
            True -> line_length + 1
            False -> 0
          }
          has_three_letter_sequence(input, i + 1, v, line_length)
        }
        True -> True
      }
    }
  }
}

fn has_two_pairs(input input, iterator i, prev_letter prev_letter, pairs pairs) {
  let letter = string.slice(input, i, 1)
  case letter != "" {
    False -> False
    True -> {
      let pair = prev_letter == letter
      case pair {
        False -> has_two_pairs(input, i + 1, letter, pairs)
        True -> {
          let pairs = pairs + 1
          case pairs {
            2 -> True
            _ -> has_two_pairs(input, i + 1, "", pairs)
          }
        }
      }
    }
  }
}

fn valid_password(input) {
  has_three_letter_sequence(input, 1, 50, 0)
  && ["i", "o", "l"]
  |> list.fold_until(True, fn(_, letter) {
    case !string.contains(input, letter) {
      False -> list.Stop(False)
      True -> list.Continue(True)
    }
  })
  && has_two_pairs(input, 0, "", 0)
}

fn increment_password(input) {
  {
    input
    |> string.to_utf_codepoints
    |> list.fold_right(#([], 0), fn(acc, letter) {
      let #(acc_str, pass) = acc
      let add = case acc_str == [] {
        True -> 1
        False -> pass
      }
      let new_letter = string.utf_codepoint_to_int(letter) + add
      let assert Ok(letter_codepoint) = string.utf_codepoint(new_letter)
      case new_letter > 122 {
        True -> {
          let assert Ok(a) = string.utf_codepoint(97)
          #(list.prepend(acc_str, a), 1)
        }
        False -> #(list.prepend(acc_str, letter_codepoint), 0)
      }
    })
  }.0
  |> string.from_utf_codepoints
}

fn get_valid_password(input) {
  case valid_password(input) {
    False -> get_valid_password(increment_password(input))
    True -> input
  }
}

pub fn main() {
  let input = read(from: "../input.txt") |> result.unwrap("") |> trim()

  let part1 = get_valid_password(input)
  println(part1)
  let part2 = get_valid_password(increment_password(part1))
  println(part2)
}
