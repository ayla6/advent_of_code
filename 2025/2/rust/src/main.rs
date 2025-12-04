use std::collections::HashSet;

struct Range {
    start: u64,
    end: u64,
}

const MAX_LENGTH: usize = 10;

fn main() {
    let input: Vec<Range> = include_str!("../../input.txt")
        .trim()
        .split(",")
        .map(|v| {
            let range = v.split_once("-");
            match range {
                Some((start, end)) => Range {
                    start: start.parse().expect("invalid number"),
                    end: end.parse().expect("invalid number"),
                },
                _ => panic!("bad input!"),
            }
        })
        .collect();

    let powers_of_ten: Vec<u64> =
        (0..=MAX_LENGTH as u32).map(|i| 10_u64.pow(i)).collect();

    let [invalid_part_1, invalid_part_2] = {
        let mut part_1: HashSet<u64> = HashSet::new();
        let mut part_2: HashSet<u64> = HashSet::new();

        for len in 1..=MAX_LENGTH / 2 {
            // 1-9, 10-99, 100-999, 100000-999999
            for combination in *powers_of_ten.get(len - 1).unwrap_or(&1)
                ..*powers_of_ten.get(len).unwrap()
            {
                let mut number = 0;
                // 0 is just the number (9), 1 is one repetition (99)
                for repeat in 0..MAX_LENGTH / len {
                    number += combination
                        * powers_of_ten.get((len * repeat) as usize).unwrap();
                    if repeat > 0 {
                        part_2.insert(number);
                    }
                    if repeat == 1 {
                        part_1.insert(number);
                    }
                }
            }
        }

        [part_1, part_2]
    };

    let part_1 = invalid_part_1.iter().fold(0, |acc, number| {
        if input.iter().any(|r| *number >= r.start && *number <= r.end) {
            acc + number
        } else {
            acc
        }
    });
    println!("{}", part_1);

    let part_2 = invalid_part_2.iter().fold(0, |acc, number| {
        if input.iter().any(|r| *number >= r.start && *number <= r.end) {
            acc + number
        } else {
            acc
        }
    });
    println!("{}", part_2);
}
