import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

fn check_containers_part1(input, remaining, right_options) {
  case remaining {
    0 -> right_options + 1
    r if r < 0 -> right_options
    _ -> {
      let #(_, right_options) =
        input
        |> dict.fold(#(input, right_options), fn(acc, cid, cv) {
          let #(input, right_options) = acc
          let input = input |> dict.delete(cid)
          #(input, check_containers_part1(input, remaining - cv, right_options))
        })
      right_options
    }
  }
}

fn check_containers_part2(input, remaining, right_options, jars_used) {
  case remaining {
    0 ->
      right_options
      |> dict.insert(
        jars_used,
        { dict.get(right_options, jars_used) |> result.unwrap(0) } + 1,
      )
    r if r < 0 -> right_options
    _ -> {
      let #(_, right_options) =
        input
        |> dict.fold(#(input, right_options), fn(acc, cid, cv) {
          let #(input, right_options) = acc
          let input = input |> dict.delete(cid)
          #(
            input,
            check_containers_part2(
              input,
              remaining - cv,
              right_options,
              jars_used + 1,
            ),
          )
        })
      right_options
    }
  }
}

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let #(input, _) =
    input
    |> string.trim
    |> string.split("\n")
    |> list.fold(#(dict.new(), 1), fn(l, v) {
      #(dict.insert(l.0, l.1, int.parse(v) |> result.unwrap(0)), l.1 + 1)
    })

  check_containers_part1(input, 150, 0)
  |> int.to_string
  |> io.println

  let #(_number_of_jars, possibilities) =
    check_containers_part2(input, 150, dict.new(), 0)
    |> dict.fold(#(999_999, 0), fn(last, number_of_jars, possibilities) {
      case last.0 > number_of_jars {
        True -> #(number_of_jars, possibilities)
        False -> last
      }
    })
  possibilities
  |> int.to_string
  |> io.println
}
