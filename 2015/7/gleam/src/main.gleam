import gleam/dict.{type Dict}
import gleam/int.{to_string}
import gleam/io.{println}
import gleam/list.{fold}
import gleam/result.{unwrap}
import gleam/string.{split, trim}
import simplifile.{read}

pub type Circuit =
  Dict(String, Operation)

pub type CircuitCache =
  Dict(String, Int)

pub type Operation {
  Set(n: String)
  Not(var: String)
  And(var1: String, var2: String)
  Or(var1: String, var2: String)
  Rshift(var1: String, var2: String)
  Lshift(var1: String, var2: String)
}

pub type GetRes {
  GetRes(value: Int, cache: CircuitCache)
}

pub fn get_circuit_var(
  circuit: Circuit,
  name: String,
  cache: CircuitCache,
) -> GetRes {
  let get = fn(name, cache) { get_circuit_var(circuit, name, cache) }

  let parsed_name = int.base_parse(name, 10)
  case result.is_ok(parsed_name) {
    True -> GetRes(parsed_name |> unwrap(0), cache)
    False -> {
      case dict.get(cache, name) {
        Ok(value) -> GetRes(value, cache)
        Error(Nil) -> {
          // will crash if it gets bad data
          let assert Ok(op) = dict.get(circuit, name)

          let #(value1, value2, cache) = case op {
            Not(v) | Set(v) -> {
              let GetRes(value, cache) = get(v, cache)
              #(value, 0, cache)
            }
            And(v1, v2) | Or(v1, v2) | Rshift(v1, v2) | Lshift(v1, v2) -> {
              let GetRes(value1, cache) = get(v1, cache)
              let GetRes(value2, cache) = get(v2, cache)
              #(value1, value2, cache)
            }
          }

          let res = case op {
            Set(_) -> value1
            Not(_) -> int.bitwise_not(value1)
            And(_, _) -> int.bitwise_and(value1, value2)
            Or(_, _) -> int.bitwise_or(value1, value2)
            Rshift(_, _) -> int.bitwise_shift_right(value1, value2)
            Lshift(_, _) -> int.bitwise_shift_left(value1, value2)
          }
          GetRes(res, dict.insert(cache, name, res))
        }
      }
    }
  }
}

pub fn main() {
  let input: Circuit =
    read(from: "../input.txt")
    |> unwrap("")
    |> trim()
    |> split("\n")
    |> fold(dict.new(), fn(circ, v) {
      case split(v, " ") {
        ["NOT", var, "->", target] -> dict.insert(circ, target, Not(var))
        [var1, "AND", var2, "->", target] ->
          dict.insert(circ, target, And(var1, var2))
        [var1, "OR", var2, "->", target] ->
          dict.insert(circ, target, Or(var1, var2))
        [var1, "RSHIFT", var2, "->", target] ->
          dict.insert(circ, target, Rshift(var1, var2))
        [var1, "LSHIFT", var2, "->", target] ->
          dict.insert(circ, target, Lshift(var1, var2))
        [v, "->", target] -> dict.insert(circ, target, Set(v))

        _ -> circ
      }
    })

  let result_part_1 = get_circuit_var(input, "a", dict.new()).value
  println(result_part_1 |> to_string)

  let input_part_2 = dict.insert(input, "b", Set(int.to_string(result_part_1)))
  let result_part_2 = get_circuit_var(input_part_2, "a", dict.new()).value
  println(result_part_2 |> to_string)
}
