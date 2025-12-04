use itertools::Itertools;

fn main() {
    let input =
        std::fs::read_to_string("../input.txt").expect("invalid input!!");
    let input = input
        .trim()
        .split("\n")
        .map(|v| v.split("x").map(|n| n.parse().expect("not a number")));

    let part1 = input.clone().fold(0, |acc, v| {
        let sides: Vec<i32> = v
            .combinations(2)
            .map(|pair| pair.into_iter().reduce(|a, b| a * b).unwrap())
            .collect();
        let sides = sides.into_iter();

        acc + sides.clone().fold(0, |acc, v| acc + v) * 2
            + sides.clone().reduce(|a, b| a.min(b)).unwrap()
    });
    println!("{part1}");

    let part2 = input.clone().fold(0, |acc, v| {
        let smallest_perimeter = v
            .clone()
            .map(|v| v * 2)
            .combinations(2)
            .map(|v| v.into_iter().fold(0, |a, b| a + b))
            .reduce(|a, b| a.min(b))
            .unwrap();

        acc + smallest_perimeter + v.fold(1, |a, b| a * b)
    });
    println!("{part2}");
}
