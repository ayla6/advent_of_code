import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub fn do(input, digits) {
  input
  // ok so here we're just iterating through all the battery banks in the input
  |> list.fold(0, fn(acc, bank) {
    let #(n, _) =
      // and here we're going and doing it the amount of times necessary. it's backwards for obvious reasons, we start from the end and this let's us not have like duplicated logic where we're doing digits - i constantly
      list.range(digits - 1, 0)
      // didn't want to create a type for it so yeah #(the digit we're at, the remaining part of the bank)
      |> list.fold(#(0, bank), fn(acc, i) {
        // annoying gleam stuff i wish i could destructure it from the function
        let #(number, bank) = acc

        // that's the part that matters, and the one i took forever in and ended up splitting in multiple variables when i didn't need to
        // but like it's very simple
        // gleam doesn't let you drop from the end of lists, so we reverse the list, drop the digits we cannot use because they will necessarily be used latter in the number. the last i is the minimum because like we need at the very least finish the number yk
        // and then the really annoying part, we turn it into an index map, so we can get the location of the number to later drop that part off for the next digit
        // and then we get the highest number
        // and done here
        // little assert because failing is better than the silent failing of unwrap
        let assert Ok(#(max, loc)) =
          bank
          |> list.reverse
          |> list.drop(i)
          |> list.reverse
          |> list.index_map(fn(n, i) { #(n, i) })
          |> list.max(fn(a, b) { int.compare(a.0, b.0) })

        // and then we send it off to the next digit
        // i wasn't using this number trick when i was doing it, i was literally just finding a power of 10 and multiplying it but like the power thing in gleam sucks it's like float only. i now learned this trick from *someone* and will be using it. don't know how i didn't figure out myself. oh wait i do it's because i'm stupid
        // but yeah it just multiplies the number by ten so like 4 becomes 40 and then we add our like 3 to it 43 and then 43 to 430 and the 5 you get the gist of it. again don't know how i didn't see it myself
        // and then we drop the parts of the list that can't be used for the subsequent numbers. like off by one evil thing in here to not include the number we just used too
        #(number * 10 + max, list.drop(bank, loc + 1))
      })
    // and then like every advent of code we add it to the acc
    acc + n
  })
}

pub fn main() {
  let assert Ok(input) = file.read(from: "../input.txt")
    as "Input file not found"
  let input =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(bank) {
      // just get all the battery banks, separate them by character and turn each character in a member of a list
      string.to_graphemes(bank)
      |> list.map(fn(s) { int.parse(s) |> result.unwrap(0) })
    })

  do(input, 2)
  |> int.to_string
  |> io.println

  do(input, 12)
  |> int.to_string
  |> io.println
}
