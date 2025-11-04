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

fn nested_decoder() -> decode.Decoder(Nested) {
  use <- decode.recursive
  decode.one_of(decode.int |> decode.map(IntValue), or: [
    decode.list(nested_decoder()) |> decode.map(NestedList),
    decode.dict(decode.string, nested_decoder()) |> decode.map(NestedDict),
    decode.string |> decode.map(StringValue),
  ])
}

fn get_total_number(data: Nested, no_red no_red) {
  case data {
    NestedList(items) ->
      items
      |> list.fold(0, fn(acc, data) { acc + get_total_number(data, no_red) })
    NestedDict(items) -> {
      let has_red =
        no_red
        && {
          items
          |> dict.values
          |> list.any(fn(data) { data == StringValue("red") })
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
    |> json.parse(nested_decoder())

  println(
    get_total_number(input, no_red: False)
    |> to_string,
  )
  println(
    get_total_number(input, no_red: True)
    |> to_string,
  )
}
