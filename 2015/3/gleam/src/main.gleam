import gleam/dict.{type Dict}
import gleam/int.{to_string}
import gleam/io.{println}
import gleam/list.{fold}
import gleam/result.{unwrap}
import gleam/string.{split, trim}
import simplifile.{read}

pub type Location {
  Location(x: Int, y: Int)
}

pub type World =
  Dict(Location, Int)

pub type State {
  State(location: Location, world: World)
}

pub type Turn {
  Santa
  Robo
}

pub type RoboState {
  RoboState(
    turn: Turn,
    santa_location: Location,
    robo_location: Location,
    world: World,
  )
}

pub fn give_gift(world: World, location: Location) {
  dict.insert(world, location, { dict.get(world, location) |> unwrap(0) } + 1)
}

pub fn move_to(location: Location, direction: String) {
  case direction {
    "^" -> Location(location.x, location.y - 1)
    "v" -> Location(location.x, location.y + 1)
    "<" -> Location(location.x - 1, location.y)
    ">" -> Location(location.x + 1, location.y)
    ___ -> Location(location.x, location.y)
  }
}

pub fn main() {
  let input = read(from: "../input.txt") |> unwrap("") |> trim() |> split("")

  // part 1
  println(
    {
      input
      |> fold(State(Location(0, 0), dict.new()), fn(state, direction) {
        let loc = state.location
        State(move_to(loc, direction), give_gift(state.world, loc))
      })
    }.world
    |> dict.size()
    |> to_string(),
  )

  // part 2
  println(
    {
      input
      |> fold(
        RoboState(Santa, Location(0, 0), Location(0, 0), dict.new()),
        fn(state, direction) {
          let sloc = state.santa_location
          let rloc = state.robo_location
          case state.turn {
            Santa ->
              RoboState(
                Robo,
                move_to(sloc, direction),
                Location(rloc.x, rloc.y),
                give_gift(state.world, sloc),
              )
            Robo ->
              RoboState(
                Santa,
                Location(sloc.x, sloc.y),
                move_to(rloc, direction),
                give_gift(state.world, rloc),
              )
          }
        },
      )
    }.world
    |> dict.size()
    |> to_string(),
  )
}
