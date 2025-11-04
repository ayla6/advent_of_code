import gleam/dict
import gleam/io.{println}
import gleam/list
import gleam/result
import gleam/string.{trim}
import simplifile.{read}

const letter_value_list = [
  #("a", 0),
  #("b", 1),
  #("c", 2),
  #("d", 3),
  #("e", 4),
  #("f", 5),
  #("g", 6),
  #("h", 7),
  #("i", 8),
  #("j", 9),
  #("k", 10),
  #("l", 11),
  #("m", 12),
  #("n", 13),
  #("o", 14),
  #("p", 15),
  #("q", 16),
  #("r", 17),
  #("s", 18),
  #("t", 19),
  #("u", 20),
  #("v", 21),
  #("w", 22),
  #("x", 23),
  #("y", 24),
  #("z", 25),
]

const value_letter_list = [
  #(0, "a"),
  #(1, "b"),
  #(2, "c"),
  #(3, "d"),
  #(4, "e"),
  #(5, "f"),
  #(6, "g"),
  #(7, "h"),
  #(8, "i"),
  #(9, "j"),
  #(10, "k"),
  #(11, "l"),
  #(12, "m"),
  #(13, "n"),
  #(14, "o"),
  #(15, "p"),
  #(16, "q"),
  #(17, "r"),
  #(18, "s"),
  #(19, "t"),
  #(20, "u"),
  #(21, "v"),
  #(22, "w"),
  #(23, "x"),
  #(24, "y"),
  #(25, "z"),
]

type LVDicts {
  LVDicts(value: dict.Dict(String, Int), letter: dict.Dict(Int, String))
}

fn has_three_letter_sequence(
  letter_value_map lvm,
  input input,
  iterator i,
  prev_letter_value prev_letter_value,
  line_length line_length,
) {
  let letter = string.slice(input, i, 1)
  let letter_value_wrap = dict.get(lvm, letter)
  case letter_value_wrap {
    Error(_) -> False
    Ok(v) -> {
      let in_sequence = prev_letter_value == v - 1
      case in_sequence && line_length == 1 {
        False -> {
          let line_length = case in_sequence {
            True -> line_length + 1
            False -> 0
          }
          has_three_letter_sequence(lvm, input, i + 1, v, line_length)
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

fn valid_password(letter_value_dict, input) {
  letter_value_dict |> has_three_letter_sequence(input, 1, 50, 0)
  && ["i", "o", "l"]
  |> list.fold_until(True, fn(_, letter) {
    case !string.contains(input, letter) {
      False -> list.Stop(False)
      True -> list.Continue(True)
    }
  })
  && has_two_pairs(input, 0, "", 0)
}

fn increment_password(lvdicts: LVDicts, input) {
  input
  |> string.split("")
  |> list.fold_right(#("", 0), fn(acc, letter) {
    let #(acc_str, pass) = acc
    let add = case acc_str == "" {
      True -> 1
      False -> pass
    }
    let value = { lvdicts.value |> dict.get(letter) |> result.unwrap(50) } + add
    case value == 26 {
      True -> #(string.append("a", acc_str), 1)
      False -> #(
        string.append(
          lvdicts.letter |> dict.get(value) |> result.unwrap("a"),
          acc_str,
        ),
        0,
      )
    }
  })
}

fn get_valid_password(lvdicts: LVDicts, input) {
  case valid_password(lvdicts.value, input) {
    False -> get_valid_password(lvdicts, increment_password(lvdicts, input).0)
    True -> input
  }
}

pub fn main() {
  let input = read(from: "../input.txt") |> result.unwrap("") |> trim()

  let letter_value_dict = dict.from_list(letter_value_list)
  let value_letter_dict = dict.from_list(value_letter_list)
  let lvdicts = LVDicts(letter_value_dict, value_letter_dict)

  let part1 = get_valid_password(lvdicts, input)
  println(part1)
  let part2 = get_valid_password(lvdicts, increment_password(lvdicts, part1).0)
  println(part2)
}
