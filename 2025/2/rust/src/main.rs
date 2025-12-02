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

    let powers_of_ten: Vec<u64> = (0..=MAX_LENGTH as u32).map(|i| 10_u64.pow(i)).collect();

    let part_1 = input.iter().fold(0_u64, |acc, v| {
        (v.start..=v.end).fold(acc, |acc, n| {
            if n <= 10 {
                return acc;
            }
            let len = (n.ilog10() + 1) as usize;
            if len % 2 == 1 {
                return acc;
            }
            let pow = powers_of_ten.get(len / 2).unwrap();
            if n / pow == n % pow {
                return acc + n;
            }
            acc
        })
    });
    println!("{}", part_1);

    let mut part_2_invalid: HashSet<u64> = HashSet::new();
    for len in 1..=MAX_LENGTH / 2 {
        // 1-9, 10-99, 100-999, 100000-999999
        for combination in
            *powers_of_ten.get(len - 1).unwrap_or(&1)..*powers_of_ten.get(len).unwrap()
        {
            let mut number = 0;
            // 0 is just the number (9), 1 is one repetition (99)
            for repeat in 0..MAX_LENGTH / len {
                number += combination * powers_of_ten.get((len * repeat) as usize).unwrap();
                if repeat > 0 {
                    part_2_invalid.insert(number);
                }
            }
        }
    }
    let part_2_invalid = part_2_invalid;

    let part_2 = input.iter().fold(0_u64, |acc, v| {
        (v.start..=v.end).fold(acc, |acc, num| {
            if num <= 10 {
                return acc;
            }
            match part_2_invalid.get(&num) {
                Some(_) => acc + num,
                _ => acc,
            }
        })
    });
    println!("{}", part_2);
}
