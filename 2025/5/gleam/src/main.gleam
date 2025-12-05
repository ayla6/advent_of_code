import gleam/int
import gleam/io
import gleam/list
import gleam/order.{Eq, Gt, Lt}
import gleam/set
import gleam/string
import simplifile as file

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let assert [fresh_ranges, available] =
    input |> string.trim |> string.split("\n\n")
  let fresh_ranges =
    fresh_ranges
    |> string.trim
    |> string.split("\n")
    // |> list.reverse
    // |> list.drop(5)
    // |> list.take(12)
    // |> list.reverse
    |> list.map(fn(i) {
      let assert [from, to] = i |> string.trim |> string.split("-")
      let assert Ok(from) = int.parse(from)
      let assert Ok(to) = int.parse(to)
      // #(from / 100_000_000, to / 100_000_000)
      #(from, to)
    })
  let available =
    available
    |> string.split("\n")
    |> list.map(fn(i) {
      let assert Ok(id) = int.parse(i)
      id
    })

  available
  |> list.fold(0, fn(acc, i) {
    acc
    + case list.any(fresh_ranges, fn(range) { i >= range.0 && i <= range.1 }) {
      True -> 1
      False -> 0
    }
  })
  |> int.to_string
  |> io.println

  // let haha =
  //   fresh_ranges
  //   |> list.fold(set.new(), fn(acc, i) {
  //     list.range(i.0, i.1) |> list.fold(acc, fn(acc, i) { set.insert(acc, i) })
  //   })
  // io.println(set.size(haha) |> int.to_string)

  let base_set: set.Set(#(Int, Int)) = set.new()
  let ranges =
    fresh_ranges
    |> list.fold(base_set, fn(prev_seen_ranges, range) {
      let #(range, seen_ranges) =
        prev_seen_ranges
        |> set.fold(#(range, prev_seen_ranges), fn(acc, seen_range) {
          let #(range, seen_ranges) = acc
          // echo #(
          //   range,
          //   seen_range,
          //   int.compare(range.0, seen_range.0),
          //   int.compare(range.1, seen_range.1),
          //   int.compare(range.0, seen_range.1),
          //   int.compare(range.1, seen_range.0),
          // )
          // btw im refusing to ever do something better than this idc about your sorting and whatever this is the way shut the fuck up i spent three hours on this i will be using it
          case
            int.compare(range.0, seen_range.0),
            int.compare(range.1, seen_range.1),
            int.compare(range.0, seen_range.1),
            int.compare(range.1, seen_range.0)
          {
            // if there's no touching
            Gt, Gt, Gt, Gt | Lt, Lt, Lt, Lt -> #(range, seen_ranges)
            // if it's inside of the other one
            Gt, Lt, _, _ | Eq, Lt, _, _ | Gt, Eq, _, _ | Eq, Eq, _, _ -> #(
              #(0, 0),
              seen_ranges,
            )
            // if the other one is inside it
            Lt, Gt, _, _ | Eq, Gt, _, _ | Lt, Eq, _, _ -> #(
              range,
              set.delete(seen_ranges, seen_range),
            )
            // if it's touching on the left side make them touch
            Lt, Lt, _, _ -> #(
              #(range.0, seen_range.1),
              set.delete(seen_ranges, seen_range),
            )
            // if it's touching on the right size make them touch
            Gt, Gt, _, _ -> #(
              #(seen_range.0, range.1),
              set.delete(seen_ranges, seen_range),
            )
          }
        })

      case range == #(0, 0) {
        False -> seen_ranges |> set.insert(range)
        True -> seen_ranges
      }
    })
  // echo ranges
  ranges
  |> set.fold(0, fn(acc, range) { acc + range.1 - range.0 + 1 })
  |> int.to_string
  |> io.println
}
