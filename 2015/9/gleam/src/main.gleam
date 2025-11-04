import gleam/dict.{type Dict}
import gleam/int.{to_string}
import gleam/io.{println}
import gleam/list
import gleam/result.{unwrap}
import gleam/set.{type Set}
import gleam/string.{trim}
import simplifile.{read}

type Distance {
  Distance(place1: String, place2: String, value: Int)
}

type TwoPlaces {
  TwoPlaces(place1: String, place2: String)
}

type DistanceDict =
  Dict(TwoPlaces, Int)

type MapPlaces {
  MapPlaces(dict: DistanceDict, places: Set(String))
}

fn find_shortest_path(distance_dict, places, shortest_path, path, place place1) {
  case set.size(places) == 0 {
    True -> path
    False ->
      places
      |> set.fold(shortest_path, fn(shortest_path, place2) {
        let assert Ok(dist) = dict.get(distance_dict, TwoPlaces(place1, place2))
        let path = path + dist
        case path < shortest_path {
          True ->
            find_shortest_path(
              distance_dict,
              places |> set.delete(place2),
              shortest_path,
              path,
              place2,
            )
          False -> shortest_path
        }
      })
  }
}

fn find_shortest_path_helper(distance_dict: DistanceDict, places: Set(String)) {
  places
  |> set.fold(1_000_000, fn(shortest_path, place1) {
    let places = places |> set.delete(place1)
    let path =
      places
      |> set.fold(shortest_path, fn(shortest_path, place2) {
        let assert Ok(path) = dict.get(distance_dict, TwoPlaces(place1, place2))
        find_shortest_path(
          distance_dict,
          places |> set.delete(place2),
          shortest_path,
          path,
          place2,
        )
      })
    case path < shortest_path {
      True -> path
      False -> shortest_path
    }
  })
}

fn find_longest_path(distance_dict, places, longest_path, path, place place1) {
  case set.size(places) == 0 {
    True ->
      case path > longest_path {
        True -> path
        False -> longest_path
      }
    False -> {
      let #(place2, longest_distance) =
        places
        |> set.fold(#("", 0), fn(longest_distance_tuple, place2) {
          let assert Ok(distance) =
            dict.get(distance_dict, TwoPlaces(place1, place2))
          let #(_, longest_distance) = longest_distance_tuple
          case distance > longest_distance {
            True -> #(place2, distance)
            False -> longest_distance_tuple
          }
        })

      let path = path + longest_distance
      find_longest_path(
        distance_dict,
        places |> set.delete(place2),
        longest_path,
        path,
        place2,
      )
    }
  }
}

fn find_longest_path_helper(distance_dict: DistanceDict, places: Set(String)) {
  places
  |> set.fold(0, fn(longest_path, place1) {
    let places = places |> set.delete(place1)
    let path =
      places
      |> set.fold(longest_path, fn(longest_path, place2) {
        let assert Ok(path) = dict.get(distance_dict, TwoPlaces(place1, place2))
        find_longest_path(
          distance_dict,
          places |> set.delete(place2),
          longest_path,
          path,
          place2,
        )
      })
    case path > longest_path {
      True -> path
      False -> longest_path
    }
  })
}

pub fn main() {
  let input =
    read(from: "../input.txt")
    |> unwrap("")
    |> trim()
    |> string.split("\n")
    |> list.map(fn(v) {
      case string.split(v, " ") {
        [place1, "to", place2, "=", distance] ->
          Distance(place1, place2, distance |> int.base_parse(10) |> unwrap(0))
        _ -> Distance("silent_fail", "because_we_are_lazy", 0)
      }
    })

  let MapPlaces(distance_dict, places) =
    input
    |> list.fold(MapPlaces(dict.new(), set.new()), fn(v, distance) {
      let map =
        dict.insert(
          v.dict,
          TwoPlaces(distance.place1, distance.place2),
          distance.value,
        )
      let map =
        dict.insert(
          map,
          TwoPlaces(distance.place2, distance.place1),
          distance.value,
        )
      let places = set.insert(v.places, distance.place1)
      let places = set.insert(places, distance.place2)
      MapPlaces(map, places)
    })

  println(
    find_shortest_path_helper(distance_dict, places)
    |> to_string,
  )
  println(
    find_longest_path_helper(distance_dict, places)
    |> to_string,
  )
}
