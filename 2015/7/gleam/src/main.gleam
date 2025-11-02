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
  Not(var: String)
  And(var1: String, var2: String)
  Or(var1: String, var2: String)
  Rshift(var: String, n: Int)
  Lshift(var: String, n: Int)
  Set(n: String)
  OpError
}

pub type GetCircRes {
  GetCircRes(value: Int, cache: CircuitCache)
}

pub fn get_circuit_var(
  circuit: Circuit,
  name: String,
  cache: CircuitCache,
) -> GetCircRes {
  let get = fn(name, cache) { get_circuit_var(circuit, name, cache) }

  let parsed_name = int.base_parse(name, 10)
  let GetCircRes(value, cache) = case result.is_ok(parsed_name) {
    True -> GetCircRes(parsed_name |> unwrap(0), cache)
    False -> {
      case dict.get(cache, name) {
        Ok(value) -> GetCircRes(value, cache)
        Error(_) -> {
          case dict.get(circuit, name) |> unwrap(OpError) {
            Not(var) -> {
              let GetCircRes(value, cache) = get(var, cache)
              GetCircRes(int.bitwise_not(value), cache)
            }
            And(var1, var2) -> {
              let GetCircRes(value1, cache) = get(var1, cache)
              let GetCircRes(value2, cache) = get(var2, cache)
              GetCircRes(int.bitwise_and(value1, value2), cache)
            }
            Or(var1, var2) -> {
              let GetCircRes(value1, cache) = get(var1, cache)
              let GetCircRes(value2, cache) = get(var2, cache)
              GetCircRes(int.bitwise_or(value1, value2), cache)
            }
            Rshift(var, n) -> {
              let GetCircRes(value, cache) = get(var, cache)
              GetCircRes(int.bitwise_shift_right(value, n), cache)
            }
            Lshift(var, n) -> {
              let GetCircRes(value, cache) = get(var, cache)
              GetCircRes(int.bitwise_shift_left(value, n), cache)
            }
            Set(var) -> get(var, cache)
            OpError -> GetCircRes(0, cache)
          }
        }
      }
    }
  }
  GetCircRes(value, dict.insert(cache, name, value))
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
        [var, "RSHIFT", n, "->", target] ->
          dict.insert(
            circ,
            target,
            Rshift(var, int.base_parse(n, 10) |> unwrap(0)),
          )
        [var, "LSHIFT", n, "->", target] ->
          dict.insert(
            circ,
            target,
            Lshift(var, int.base_parse(n, 10) |> unwrap(0)),
          )
        [v, "->", target] -> dict.insert(circ, target, Set(v))

        _ -> circ
      }
    })

  let result_part_1 = get_circuit_var(input, "a", dict.new()).value
  println(result_part_1 |> to_string)

  let result_part_2 =
    get_circuit_var(
      dict.insert(input, "b", Set(int.to_string(result_part_1))),
      "a",
      dict.new(),
    ).value
  println(result_part_2 |> to_string)
}
