import gleam/int.{to_string}
import gleam/io.{println}
import gleam/list.{fold}
import gleam/regexp.{check}
import gleam/result.{unwrap}
import gleam/string.{split, trim}
import simplifile.{read}

// regex feels like cheating idk

pub fn is_nice_part_1(str: String) {
  let assert Ok(has_three_vowels) =
    regexp.from_string(".*?[aeiou].*?[aeiou].*?[aeiou].*?")
  let assert Ok(has_doubled_letter) = regexp.from_string("([a-z])\\1")
  let assert Ok(has_bad_string) = regexp.from_string("(ab|cd|pq|xy)")

  { has_three_vowels |> check(str) }
  && { has_doubled_letter |> check(str) }
  && !{ has_bad_string |> check(str) }
}

pub fn is_nice_part_2(str: String) {
  let assert Ok(has_doubled_pair) = regexp.from_string("([a-z])[a-z]\\1")
  let assert Ok(has_letter1_letter2_letter1) =
    regexp.from_string("([a-z][a-z]).*?\\1")

  { has_doubled_pair |> check(str) }
  && { has_letter1_letter2_letter1 |> check(str) }
}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim |> split("\n")

  println(
    input
    |> fold(0, fn(acc, str) {
      case is_nice_part_1(str) {
        True -> acc + 1
        False -> acc
      }
    })
    |> to_string,
  )

  println(
    input
    |> fold(0, fn(acc, str) {
      case is_nice_part_2(str) {
        True -> acc + 1
        False -> acc
      }
    })
    |> to_string,
  )
}
