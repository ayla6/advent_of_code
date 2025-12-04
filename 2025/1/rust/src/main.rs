struct State {
    turn: i32,
    zeroes: i32,
}

fn main() {
    let input: Vec<i32> = include_str!("../../input.txt")
        .trim()
        .split("\n")
        .map(|n| {
            n.replace("L", "-")
                .replace("R", "")
                .parse::<i32>()
                .expect("invalid input")
        })
        .collect();

    let part_1 = input.iter().fold(
        State {
            turn: 50,
            zeroes: 0,
        },
        |acc, n| {
            let turn = (acc.turn + n).rem_euclid(100);
            State {
                turn,
                zeroes: acc.zeroes + (turn == 0) as i32,
            }
        },
    );
    println!("{}", part_1.zeroes);

    let part_2 = input.iter().fold(
        State {
            turn: 50,
            zeroes: 0,
        },
        |acc, n| {
            let raw_turn = acc.turn + n;
            let turn = raw_turn.rem_euclid(100);
            let raw_zeroes = (raw_turn / 100).abs();
            State {
                turn,
                // if it is below zero before being moduloed and the original number itself wasn't zero it means that it did touch zero but the division thing wouldn't count it, so we give this extra support.
                // of course, there is no need to deal with a negative to positive situation because the acc.turn will never be negative!!!
                zeroes: acc.zeroes
                    + raw_zeroes
                    + (acc.turn != 0 && raw_turn <= 0) as i32,
            }
        },
    );
    println!("{}", part_2.zeroes);
}
