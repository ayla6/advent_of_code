use std::mem::swap;

fn solve(mut warehouse: Vec<u8>, size: usize, part_2: bool) -> u32 {
    let pos = |x, y| y * (size + 2) + x;

    let sizep = size + 1;

    let mut new_warehouse = vec![0_u8; (size + 2).pow(2)];

    let mut rolls = 0;

    loop {
        for yo in 1..sizep {
            let ym = yo - 1;
            let yp = yo + 1;
            for xo in 1..sizep {
                let xm = xo - 1;
                let xp = xo + 1;

                unsafe {
                    let was = *warehouse.get_unchecked(pos(xo, yo)) == 1;
                    let neighbours = warehouse.get_unchecked(pos(xm, ym))
                        + warehouse.get_unchecked(pos(xo, ym))
                        + warehouse.get_unchecked(pos(xp, ym))
                        + warehouse.get_unchecked(pos(xm, yo))
                        + warehouse.get_unchecked(pos(xp, yo))
                        + warehouse.get_unchecked(pos(xm, yp))
                        + warehouse.get_unchecked(pos(xo, yp))
                        + warehouse.get_unchecked(pos(xp, yp));
                    *new_warehouse.get_unchecked_mut(pos(xo, yo)) =
                        match (was, neighbours < 4) {
                            (true, true) => {
                                rolls += 1;
                                0
                            }
                            (true, false) => 1,
                            (_, _) => 0,
                        };
                }
            }
        }

        if !part_2 || warehouse == new_warehouse {
            break;
        }

        swap(&mut warehouse, &mut new_warehouse);
    }
    rolls
}

fn main() {
    let input = include_str!("../../input.txt").trim();
    let size = input.split_once("\n").expect("invalid input").0.len();
    // reads the input but adds a line of buffer on the sides
    let buffer_line = ".".repeat(size);
    let input: Vec<u8> = format!("{buffer_line}\n{input}\n{buffer_line}")
        .split("\n")
        .map(|line| -> Vec<u8> {
            format!(".{}.", line)
                .chars()
                .map(|v| (v == '@') as u8)
                .collect()
        })
        .flatten()
        .collect();

    let part_1 = solve(input.clone(), size, false);
    println!("Part 1: {}", part_1);

    let part_2 = solve(input.clone(), size, true);
    println!("Part 2: {}", part_2);
}
