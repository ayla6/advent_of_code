import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile.{read}

pub type Relation {
  Relation(person: String, neighbor: String)
}

pub type SingularHappiness =
  Int

pub type SingularHappinessDict =
  Dict(Relation, SingularHappiness)

pub type Happiness =
  Int

pub type HappinessDict =
  Dict(Relation, Happiness)

pub type People =
  Set(String)

pub type Sign {
  Gain
  Lose
}

fn do_find_happiest_table(
  happiness_dict,
  people,
  happiest_table,
  first_person first_person,
  last_person last_person,
  table table,
) {
  case set.size(people) == 0 {
    True -> {
      let assert Ok(relation) =
        happiness_dict |> dict.get(Relation(last_person, first_person))
        as "There should be more than one person"
      let table = table + relation
      case table > happiest_table {
        True -> table
        False -> happiest_table
      }
    }
    False -> {
      people
      |> set.fold(0, fn(happiest_table, person) {
        let assert Ok(relation) =
          happiness_dict |> dict.get(Relation(last_person, person))
          as {
            "Relation between "
            <> { last_person <> " and " <> person }
            <> " was not found"
          }
        // gonna be honest i have no idea why this part works i feel ashamed
        let table =
          table
          + relation
          + do_find_happiest_table(
            happiness_dict,
            people |> set.delete(person),
            happiest_table,
            first_person,
            last_person: person,
            table: table,
          )
        case table > happiest_table {
          True -> table
          False -> happiest_table
        }
      })
    }
  }
}

pub fn find_happiest_table(happiness_dict: HappinessDict, people: People) {
  let assert Ok(person) = people |> set.to_list |> list.first
    as "People list is empty"
  do_find_happiest_table(
    happiness_dict,
    people |> set.delete(person),
    0,
    first_person: person,
    last_person: person,
    table: 0,
  )
}

pub fn parse_sign(sign: String) {
  case sign {
    "gain" -> Ok(Gain)
    "lose" -> Ok(Lose)
    _ -> Error("Some sign input was neither gain or lose: " <> sign)
  }
}

pub fn main() {
  let assert Ok(input) = read(from: "../input.txt") as "Input file not found"

  let singular_happiness_dict: SingularHappinessDict =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(value) {
      case value |> string.split(" ") {
        // (person) would (gain/lose) (amount) happiness units by sitting next to (neighbor.)
        [person, _, sign, happiness, _, _, _, _, _, _, neighbor] -> {
          let assert Ok(happiness) = happiness |> int.base_parse(10)
            as { "Happiness values should be integers: " <> happiness }
          let sign = case parse_sign(sign) {
            Ok(sign) -> sign
            Error(message) -> panic as message
          }
          let happiness = case sign {
            Gain -> happiness
            Lose -> happiness |> int.negate
          }

          let neighbor = case neighbor |> string.last {
            Ok(".") -> neighbor |> string.drop_end(1)
            _ -> panic as { "Neighbor didn't end in a dot: " <> neighbor }
          }

          #(Relation(person, neighbor), happiness)
        }
        _ -> panic as { "Value doesn't match constrainsts" <> value }
      }
    })
    |> dict.from_list

  let happiness_dict: HappinessDict =
    singular_happiness_dict
    |> dict.fold(dict.new(), fn(hd, relation, singular_happiness) {
      let Relation(person1, person2) = relation

      case hd |> dict.has_key(relation) {
        False -> {
          let other_relation = Relation(person2, person1)
          let assert Ok(other_singular_happiness) =
            singular_happiness_dict |> dict.get(other_relation)
            as "Malformed singular_happiness_dict"
          let total_happiness = singular_happiness + other_singular_happiness

          hd
          |> dict.insert(relation, total_happiness)
          |> dict.insert(other_relation, total_happiness)
        }
        True -> hd
      }
    })

  let people: People =
    singular_happiness_dict
    |> dict.fold(set.new(), fn(people, relation, _) {
      people |> set.insert(relation.person)
    })

  "Part 1" |> io.println
  let happiest_table = find_happiest_table(happiness_dict, people)
  happiest_table |> int.to_string |> io.println

  "Part 2" |> io.println
  let relations_with_me: SingularHappinessDict =
    people
    |> set.to_list
    |> list.map(fn(person) {
      [#(Relation(person, "Me"), 0), #(Relation("Me", person), 0)]
    })
    |> list.flatten
    |> dict.from_list
  let happiness_dict = happiness_dict |> dict.merge(relations_with_me)
  let people = people |> set.insert("Me")

  let happiest_table_with_me = find_happiest_table(happiness_dict, people)
  "With me: " |> io.print
  happiest_table_with_me |> int.to_string |> io.println
}
