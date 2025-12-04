import gleam/bit_array
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

fn get_place(x, y, map, size) {
  case
    case x, y {
      _, -1 | -1, _ -> <<>>
      s, _ | _, s if s == size -> <<>>

      _, _ -> bit_array.slice(map, y * size + x, 1) |> result.unwrap(<<>>)
    }
  {
    <<"@">> -> 1
    _ -> 0
  }
}

fn part_1(map, size) {
  list.range(0, bit_array.byte_size(map) - 1)
  |> list.fold(0, fn(acc, pos) {
    let x = pos % size
    let y = pos / size

    let roll = get_place(x, y, map, size)

    let neighbours =
      get_place(x - 1, y - 1, map, size)
      + get_place(x, y - 1, map, size)
      + get_place(x + 1, y - 1, map, size)
      + get_place(x - 1, y, map, size)
      + get_place(x + 1, y, map, size)
      + get_place(x - 1, y + 1, map, size)
      + get_place(x, y + 1, map, size)
      + get_place(x + 1, y + 1, map, size)

    case roll, neighbours < 4 {
      1, True -> acc + 1
      _, _ -> acc
    }
  })
}

fn part_2(map, size, rolls) {
  let #(rolls, new_map) =
    list.range(0, bit_array.byte_size(map) - 1)
    |> list.fold(#(rolls, <<>>), fn(acc, pos) {
      let #(total, new_map) = acc
      let x = pos % size
      let y = pos / size

      let roll = get_place(x, y, map, size)

      let neighbours =
        get_place(x - 1, y - 1, map, size)
        + get_place(x, y - 1, map, size)
        + get_place(x + 1, y - 1, map, size)
        + get_place(x - 1, y, map, size)
        + get_place(x + 1, y, map, size)
        + get_place(x - 1, y + 1, map, size)
        + get_place(x, y + 1, map, size)
        + get_place(x + 1, y + 1, map, size)

      case roll, neighbours < 4 {
        1, True -> #(total + 1, bit_array.append(new_map, <<".">>))
        0, _ -> #(total, bit_array.append(new_map, <<".">>))
        1, _ | _, _ -> #(total, bit_array.append(new_map, <<"@">>))
      }
    })

  case map == new_map {
    True -> rolls
    False -> part_2(new_map, size, rolls)
  }
}

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input =
    input |> string.trim |> string.split("\n") |> list.map(fn(v) { <<v:utf8>> })
  let size = list.length(input)
  let input = input |> list.fold(<<>>, fn(acc, l) { bit_array.append(acc, l) })
  // @ and .

  part_1(input, size)
  |> int.to_string
  |> io.println
  part_2(input, size, 0)
  |> int.to_string
  |> io.println
}
