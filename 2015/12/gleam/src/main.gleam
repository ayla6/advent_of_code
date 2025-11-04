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

fn handle_calc(data: Nested, no_red) {
  case data {
    NestedList(items) -> get_total_number_list(items, no_red)
    NestedDict(items) -> get_total_number_dict(items, no_red)
    IntValue(v) -> v
    _ -> 0
  }
}

fn get_total_number_dict(data: Dict(String, Nested), no_red) {
  let has_red = case no_red {
    True ->
      data
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
      data
      |> dict.fold(0, fn(acc, _, data) { acc + handle_calc(data, no_red) })
  }
}

fn get_total_number_list(data: List(Nested), no_red no_red) {
  data
  |> list.fold(0, fn(acc, data) { acc + handle_calc(data, no_red) })
}

pub fn main() {
  let assert Ok(input) =
    read(from: "../input.json")
    |> unwrap("")
    |> json.parse(int_anywhere_decoder())

  println(
    get_total_number_list([input], no_red: False)
    |> to_string,
  )
  println(
    get_total_number_list([input], no_red: True)
    |> to_string,
  )
}
