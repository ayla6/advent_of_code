import gleam/bit_array
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

fn solve(input, size) {
  let get_place = fn(x, y) {
    case
      case x, y {
        _, -1 | -1, _ -> <<>>
        s, _ | _, s if s == size -> <<>>

        _, _ -> bit_array.slice(input, y * size + x, 1) |> result.unwrap(<<>>)
      }
    {
      <<"@">> -> 1
      _ -> 0
    }
  }

  list.range(0, bit_array.byte_size(input) - 1)
  |> list.fold(0, fn(acc, pos) {
    let x = pos % size
    let y = pos / size

    let roll = get_place(x, y)

    let neighbours =
      get_place(x - 1, y - 1)
      + get_place(x, y - 1)
      + get_place(x + 1, y - 1)
      + get_place(x - 1, y)
      + get_place(x + 1, y)
      + get_place(x - 1, y + 1)
      + get_place(x, y + 1)
      + get_place(x + 1, y + 1)

    case roll, neighbours < 4 {
      1, True -> acc + 1
      _, _ -> acc
    }
  })
}

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input =
    input |> string.trim |> string.split("\n") |> list.map(fn(v) { <<v:utf8>> })
  let size = list.length(input)
  let input = input |> list.fold(<<>>, fn(acc, l) { bit_array.append(acc, l) })
  // @ and .

  solve(input, size)
  |> int.to_string
  |> io.println
}
