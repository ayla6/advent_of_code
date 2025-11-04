import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/int.{to_string}
import gleam/io.{println}
import gleam/json
import gleam/list
import gleam/result.{unwrap}
import simplifile.{read}

type Nested {
  NestedList(List(Nested))
  NestedDict(Dict(String, Nested))
  IntValue(Int)
  StringValue(String)
}

fn int_anywhere_decoder() -> decode.Decoder(Nested) {
  use <- decode.recursive
  decode.one_of(decode.int |> decode.map(IntValue), or: [
    decode.list(int_anywhere_decoder()) |> decode.map(NestedList),
    decode.dict(decode.string, int_anywhere_decoder()) |> decode.map(NestedDict),
    decode.string |> decode.map(StringValue),
  ])
}

fn get_total_number(data: Nested, no_red no_red) {
  case data {
    NestedList(items) ->
      items
      |> list.fold(0, fn(acc, data) { acc + get_total_number(data, no_red) })
    NestedDict(items) -> {
      let has_red = case no_red {
        True ->
          items
          |> dict.fold(False, fn(state, _, data) {
            case data {
              StringValue("red") -> True
              _ -> state
            }
          })
        False -> False
      }
      case has_red {
        True -> 0
        False ->
          items
          |> dict.fold(0, fn(acc, _, data) {
            acc + get_total_number(data, no_red)
          })
      }
    }
    IntValue(v) -> v
    _ -> 0
  }
}

pub fn main() {
  let assert Ok(input) =
    read(from: "../input.json")
    |> unwrap("")
    |> json.parse(int_anywhere_decoder())

  println(
    get_total_number(input, no_red: False)
    |> to_string,
  )
  println(
    get_total_number(input, no_red: True)
    |> to_string,
  )
}
