import gleam/int.{to_string}
import gleam/io.{println}
import gleam/list
import gleam/result.{unwrap}
import gleam/string.{split, trim}
import simplifile.{read}

pub fn get_mem_size(str, cur_size, i) {
  case string.slice(str, i, 2) {
    "" -> cur_size
    "\\\\" | "\\\"" -> get_mem_size(str, cur_size + 1, i + 2)
    "\\x" -> get_mem_size(str, cur_size + 1, i + 4)
    _ -> get_mem_size(str, cur_size + 1, i + 1)
  }
}

pub fn get_mem_size_helper(str: String) {
  get_mem_size(string.slice(str, 1, string.length(str) - 2), 0, 0)
}

pub fn get_encoded_size(str, cur_size, i) {
  let char = string.slice(str, i, 1)
  case char {
    "" -> cur_size + 2
    "\\" | "\"" -> get_encoded_size(str, cur_size + 2, i + 1)
    _ -> get_encoded_size(str, cur_size + 1, i + 1)
  }
}

pub fn main() {
  let input =
    read(from: "../input.txt")
    |> unwrap("")
    |> trim()
    |> split("\n")

  let result_part_1 =
    input
    |> list.fold(0, fn(total, str) {
      total + { string.length(str) - get_mem_size_helper(str) }
    })
  println(result_part_1 |> to_string)

  let result_part_2 =
    input
    |> list.fold(0, fn(total, str) {
      total + { get_encoded_size(str, 0, 0) - string.length(str) }
    })
  println(result_part_2 |> to_string)
}
