use std::{
    cmp::Ordering::{Equal as Eq, Greater as Gt, Less as Lt},
    collections::HashSet,
};

fn main() {
    let input = include_str!("../../input.txt").trim();
    let (fresh_ranges, available) = input.split_once("\n\n").unwrap();
    let fresh_ranges: Vec<(u64, u64)> = fresh_ranges
        .split("\n")
        .map(|i| {
            let (a, b) = i.split_once("-").unwrap();
            (a.parse().unwrap(), b.parse().unwrap())
        })
        .collect();
    let available = available.split("\n").map(|i| {
        let i: u64 = i.parse().unwrap();
        i
    });

    let part_1 = available.fold(0, |acc, i| {
        acc + fresh_ranges
            .iter()
            .any(|(start, end)| &i >= start && &i <= end) as u64
    });
    println!("Part 1: {}", part_1);

    let mut seen_ranges: HashSet<(u64, u64)> =
        HashSet::with_capacity(fresh_ranges.len());
    fresh_ranges.iter().for_each(|range| {
        let range = seen_ranges.clone().iter().try_fold(
            *range,
            |range: (u64, u64), seen_range: &(u64, u64)| {
                // btw im refusing to ever do something better than this idc about your sorting and whatever this is the way shut the fuck up i spent three hours on this i will be using it
                match (
                    range.0.cmp(&seen_range.0),
                    range.1.cmp(&seen_range.1),
                    range.0.cmp(&seen_range.1),
                    range.1.cmp(&seen_range.0),
                ) {
                    // if there's no touching
                    (Gt, Gt, Gt, Gt) | (Lt, Lt, Lt, Lt) => Some(range),
                    // if it's inside of the other one
                    (Gt, Lt, _, _)
                    | (Eq, Lt, _, _)
                    | (Gt, Eq, _, _)
                    | (Eq, Eq, _, _) => None,
                    // if the other one is inside it
                    (Lt, Gt, _, _) | (Eq, Gt, _, _) | (Lt, Eq, _, _) => {
                        seen_ranges.remove(seen_range);
                        Some(range)
                    }
                    // if it's touching on the left side make them touch
                    (Lt, Lt, _, _) => {
                        seen_ranges.remove(seen_range);
                        Some((range.0, seen_range.1))
                    }
                    // if it's touching on the right size make them touch
                    (Gt, Gt, _, _) => {
                        seen_ranges.remove(seen_range);
                        Some((seen_range.0, range.1))
                    }
                }
            },
        );

        if range.is_some() {
            seen_ranges.insert(range.unwrap());
        }
    });
    let part_2 = seen_ranges
        .into_iter()
        .fold(0, |acc, range| acc + range.1 - range.0 + 1);
    println!("Part 2: {}", part_2);
}
