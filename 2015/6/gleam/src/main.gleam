import gleam/dict.{type Dict}
import gleam/int.{to_string}
import gleam/io.{println}
import gleam/list.{fold, map}
import gleam/result.{unwrap}
import gleam/string.{split, trim}
import simplifile.{read}

pub type Location {
  Location(x: Int, y: Int)
}

pub type ActionType {
  Toggle
  TurnOn
  TurnOff
}

pub type Action {
  Action(atype: ActionType, loc1: Location, loc2: Location)
}

pub type Grid =
  Dict(Location, Bool)

pub type GridInt =
  Dict(Location, Int)

pub fn str_to_loc(str) -> Location {
  let extract =
    str
    |> split(",")
    |> map(fn(v) { int.base_parse(v, 10) |> unwrap(0) })
  case extract {
    [x, y] -> Location(x, y)
    _ -> Location(0, 0)
  }
}

pub fn do_action(grid: Grid, action: Action) {
  list.range(action.loc1.y, action.loc2.y)
  |> fold(grid, fn(grid, y) {
    list.range(action.loc1.x, action.loc2.x)
    |> fold(grid, fn(grid, x) {
      let loc = Location(x, y)
      let value = case action.atype {
        Toggle -> !{ grid |> dict.get(loc) |> unwrap(False) }
        TurnOff -> False
        TurnOn -> True
      }
      grid |> dict.insert(loc, value)
    })
  })
}

pub fn get_grid_true_count(grid: Grid) {
  grid
  |> dict.fold(0, fn(cur, _, v) {
    case v {
      True -> cur + 1
      False -> cur
    }
  })
}

pub fn do_action_int(grid: GridInt, action: Action) {
  list.range(action.loc1.y, action.loc2.y)
  |> fold(grid, fn(grid, y) {
    list.range(action.loc1.x, action.loc2.x)
    |> fold(grid, fn(grid, x) {
      let loc = Location(x, y)
      let cur = grid |> dict.get(loc) |> unwrap(0)
      let value = case action.atype {
        Toggle -> cur + 2
        TurnOff -> int.max(0, cur - 1)
        TurnOn -> int.max(0, cur + 1)
      }
      grid |> dict.insert(loc, value)
    })
  })
}

pub fn get_grid_total_brightness(grid: GridInt) {
  grid
  |> dict.fold(0, fn(cur, _, v) { cur + v })
}

pub fn main() {
  let input =
    read(from: "../input.txt")
    |> unwrap("")
    |> trim()
    |> split("\n")
    |> list.map(fn(v) {
      let split_v = split(v, " ")
      case split_v {
        ["toggle", loc1, _, loc2] ->
          Action(Toggle, str_to_loc(loc1), str_to_loc(loc2))
        ["turn", "off", loc1, _, loc2] ->
          Action(TurnOff, str_to_loc(loc1), str_to_loc(loc2))
        ["turn", "on", loc1, _, loc2] ->
          Action(TurnOn, str_to_loc(loc1), str_to_loc(loc2))
        _ -> Action(Toggle, Location(0, 0), Location(0, 0))
      }
    })

  println(
    input
    |> list.fold(dict.new(), fn(grid, a) { grid |> do_action(a) })
    |> get_grid_true_count
    |> to_string,
  )

  println(
    input
    |> list.fold(dict.new(), fn(grid, a) { grid |> do_action_int(a) })
    |> get_grid_total_brightness
    |> to_string,
  )
}
