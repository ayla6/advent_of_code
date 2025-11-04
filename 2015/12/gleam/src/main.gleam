import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/dynamic/decode
import gleam/int.{to_string}
import gleam/io.{println}
import gleam/json
import gleam/list
import gleam/result.{unwrap}
import gleam/string.{trim}
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

fn get_total_number_dict(data: Dict(String, Nested)) {
  data
  |> dict.fold(0, fn(acc, _, data) {
    let add = case data {
      NestedList(items) -> get_total_number_list(items)
      NestedDict(items) -> get_total_number_dict(items)
      IntValue(v) -> v
      _ -> 0
    }
    acc + add
  })
}

fn get_total_number_list(data: List(Nested)) {
  data
  |> list.fold(0, fn(acc, data) {
    let add = case data {
      NestedList(items) -> get_total_number_list(items)
      NestedDict(items) -> get_total_number_dict(items)
      IntValue(v) -> v
      _ -> 0
    }
    acc + add
  })
}

fn get_total_number_dict_no_red(data: Dict(String, Nested)) {
  let has_red =
    data
    |> dict.fold(False, fn(state, _, data) {
      case data {
        StringValue("red") -> True
        _ -> state
      }
    })
  case has_red {
    True -> 0
    False ->
      data
      |> dict.fold(0, fn(acc, _, data) {
        let add = case data {
          NestedList(items) -> get_total_number_list_no_red(items)
          NestedDict(items) -> get_total_number_dict_no_red(items)
          IntValue(v) -> v
          _ -> 0
        }
        acc + add
      })
  }
}

fn get_total_number_list_no_red(data: List(Nested)) {
  data
  |> list.fold(0, fn(acc, data) {
    let add = case data {
      NestedList(items) -> get_total_number_list_no_red(items)
      NestedDict(items) -> get_total_number_dict_no_red(items)
      IntValue(v) -> v
      _ -> 0
    }
    acc + add
  })
}

pub fn main() {
  let assert Ok(input) =
    read(from: "../input.json")
    |> unwrap("")
    |> json.parse(int_anywhere_decoder())

  println(
    get_total_number_list([input])
    |> to_string,
  )
  println(
    get_total_number_list_no_red([input])
    |> to_string,
  )
}
