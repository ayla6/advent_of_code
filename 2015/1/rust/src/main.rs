use std::{fs, ops::ControlFlow};

fn main() {
    let input = fs::read_to_string("../input.txt").expect("invalid input");
    let input = input.trim();

    let part1 = input.chars().fold(0, |floor, v| {
        (match v {
            '(' => 1,
            ')' => -1,
            _ => 0,
        }) + floor
    });

    println!("{}", part1);

    let part2 = input.chars().try_fold((0, 1), |(floor, step), v| {
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
        ControlFlow::Continue(_) => panic!("bad input. never reached basement"),
    };

    println!("{}", part2);
}
