import gleam/bit_array
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

fn generation(input: BitArray, size: Int, stuck: Bool) {
  let get_place = fn(x, y) {
    case
      case stuck, x, y {
        True, 0, 0 -> <<"#">>
        True, 0, s | True, s, 0 if s == size - 1 -> <<"#">>
        True, s1, s2 if s1 == size - 1 && s1 == s2 -> <<"#">>

        _, _, -1 | _, -1, _ -> <<>>
        _, s, _ | _, _, s if s == size -> <<>>

        _, _, _ ->
          bit_array.slice(input, y * size + x, 1) |> result.unwrap(<<>>)
      }
    {
      <<"#">> -> 1
      _ -> 0
    }
  }

  list.range(0, bit_array.byte_size(input) - 1)
  |> list.fold(<<>>, fn(res, pos) {
    let x = pos % size
    let y = pos / size

    let cell = get_place(x, y)

    let neighbours =
      get_place(x - 1, y - 1)
      + get_place(x, y - 1)
      + get_place(x + 1, y - 1)
      + get_place(x - 1, y)
      + get_place(x + 1, y)
      + get_place(x - 1, y + 1)
      + get_place(x, y + 1)
      + get_place(x + 1, y + 1)

    bit_array.append(res, case stuck, x, y {
      True, 0, 0 -> <<"#">>
      True, 0, s | True, s, 0 if s == size - 1 -> <<"#">>
      True, s1, s2 if s1 == size - 1 && s1 == s2 -> <<"#">>

      _, _, _ ->
        case cell, neighbours {
          _, 3 | 1, 2 -> <<"#">>
          _, _ -> <<".">>
        }
    })
  })
}

fn check_lights_on(input: BitArray) {
  list.range(0, bit_array.byte_size(input) - 1)
  |> list.fold(0, fn(res, pos) {
    let assert Ok(cell) = bit_array.slice(input, pos, 1)
    case cell {
      <<"#">> -> res + 1
      _ -> res
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

  list.range(1, 100)
  |> list.fold(input, fn(last, _) { generation(last, size, False) })
  |> check_lights_on
  |> int.to_string
  |> io.println

  list.range(1, 100)
  |> list.fold(input, fn(last, _) { generation(last, size, True) })
  |> check_lights_on
  |> int.to_string
  |> io.println
}
