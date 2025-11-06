import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/order.{Eq, Gt, Lt}
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile as file

pub type Reindeer {
  Reindeer(name: String, speed: Int, run: Int, rest: Int)
}

pub type Action {
  Run
  Rest
}

pub type ReindeerState {
  ReindeerState(km: Int, action: Action, time_until_change: Int)
}

pub type RunState =
  dict.Dict(String, ReindeerState)

pub type ReindeerStatePoints {
  ReindeerStatePoints(
    points: Int,
    km: Int,
    action: Action,
    time_until_change: Int,
  )
}

pub type LeadKm {
  LeadKm(km: Int, leads: Set(String))
}

pub type RunStatePoints {
  RunStatePoints(lead_km: LeadKm, state: Dict(String, ReindeerStatePoints))
}

pub fn to_int(number_string) {
  let assert Ok(number) = number_string |> int.base_parse(10)
    as { number_string <> " is not a number" }
  number
}

pub fn do_calculate_run_state(state: RunState, reindeers: List(Reindeer), sec) {
  case sec > 0 {
    False -> state
    True -> {
      reindeers
      |> list.fold(state, fn(state, reindeer) {
        let Reindeer(name, speed, run, rest) = reindeer
        let ReindeerState(km, action, time_until_change) =
          state
          |> dict.get(reindeer.name)
          |> result.unwrap(ReindeerState(0, Run, run))

        let km = case action {
          Run -> km + speed
          Rest -> km
        }
        case time_until_change, action {
          1, Run -> ReindeerState(km, Rest, rest)
          1, Rest -> ReindeerState(km, Run, run)
          _, _ -> ReindeerState(km, action, time_until_change - 1)
        }
        |> dict.insert(state, name, _)
      })
      |> do_calculate_run_state(reindeers, sec - 1)
    }
  }
}

pub fn calculate_run_state(reindeers: List(Reindeer), sec: Int) {
  do_calculate_run_state(dict.new(), reindeers, sec)
}

pub fn get_winner_km(state: RunState) {
  state
  |> dict.fold(0, fn(winner, _, state) {
    case state.km > winner {
      True -> state.km
      False -> winner
    }
  })
}

pub fn do_calculate_run_state_pt2(
  state: RunStatePoints,
  reindeers: List(Reindeer),
  sec,
) {
  case sec > 0 {
    False -> state
    True -> {
      let RunStatePoints(LeadKm(_, leads), state) =
        reindeers
        |> list.fold(state, fn(s, reindeer) {
          let RunStatePoints(lead_km, state) = s
          let Reindeer(name, speed, run, rest) = reindeer
          let ReindeerStatePoints(points, km, action, time_until_change) =
            state
            |> dict.get(reindeer.name)
            |> result.unwrap(ReindeerStatePoints(0, 0, Run, run))

          let km = case action {
            Run -> km + speed
            Rest -> km
          }
          let state =
            case time_until_change, action {
              1, Run -> ReindeerStatePoints(points, km, Rest, rest)
              1, Rest -> ReindeerStatePoints(points, km, Run, run)
              _, _ ->
                ReindeerStatePoints(points, km, action, time_until_change - 1)
            }
            |> dict.insert(state, name, _)

          let lead_km = case int.compare(km, lead_km.km) {
            Eq -> LeadKm(km, lead_km.leads |> set.insert(name))
            Gt -> LeadKm(km, set.new() |> set.insert(name))
            Lt -> lead_km
          }

          RunStatePoints(lead_km, state)
        })

      let state =
        leads
        |> set.fold(state, fn(state, reindeer_name) {
          let assert Ok(ReindeerStatePoints(
            points,
            km,
            action,
            time_until_change,
          )) =
            state
            |> dict.get(reindeer_name)
          state
          |> dict.insert(
            reindeer_name,
            ReindeerStatePoints(points + 1, km, action, time_until_change),
          )
        })

      RunStatePoints(LeadKm(0, set.new()), state)
      |> do_calculate_run_state_pt2(reindeers, sec - 1)
    }
  }
}

pub fn calculate_run_state_pt2(reindeers: List(Reindeer), sec: Int) {
  do_calculate_run_state_pt2(
    RunStatePoints(LeadKm(0, set.new()), dict.new()),
    reindeers,
    sec,
  )
}

pub fn get_winner_points(state: RunStatePoints) {
  state.state
  |> dict.fold(0, fn(winner, _, state) {
    case state.points > winner {
      True -> state.points
      False -> winner
    }
  })
}

pub fn main() {
  let assert Ok(reindeer) = file.read(from: "../input.txt")
    as "Input file not found"
  let reindeer =
    reindeer
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(v) {
      case v |> string.split(" ") {
        // (name) can fly (speed) km/s for (run) seconds, but then must rest for (rest) seconds.
        [name, _, _, speed, _, _, run, _, _, _, _, _, _, rest, _] ->
          Reindeer(name, speed |> to_int, run |> to_int, rest |> to_int)
        _ -> panic as { v <> " is not a valid line" }
      }
    })

  "Part 1" |> io.println
  reindeer
  |> calculate_run_state(2503)
  |> get_winner_km
  |> int.to_string
  |> io.println

  "Part 2" |> io.println
  reindeer
  |> calculate_run_state_pt2(2503)
  |> get_winner_points
  |> int.to_string
  |> io.println
}
