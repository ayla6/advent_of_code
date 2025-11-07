use std::{fs, ops::ControlFlow};

fn main() {
    let input: String = match fs::read_to_string("../input.txt") {
        Ok(input) => input,
        _ => panic!("invalid input!!!"),
    };
    let input = input.trim();

    let part1 = input.chars().fold(0, |floor, v| {
        (match v {
            '(' => 1,
            ')' => -1,
            _ => 0,
        }) + floor
    });

    println!("{}", part1.to_string());

    let part2 = input.chars().try_fold((0, 1), |state, v| {
        let (floor, step) = state;
        let floor = (match v {
            '(' => 1,
            ')' => -1,
            _ => 0,
        }) + floor;
        match floor {
            -1 => ControlFlow::Break(step),
            _ => ControlFlow::Continue((floor, step + 1)),
        }
    });
    let part2 = match part2 {
        ControlFlow::Break(part2) => part2,
        _ => panic!("something bad happened"),
    };

    println!("{}", part2.to_string());
}
