use std::mem::swap;

fn generations(mut world: Vec<u8>, size: usize, part_2: bool) -> u32 {
    let pos = |x, y| y * (size + 2) + x;

    let sizep = size + 1;

    let mut new_world = vec![0_u8; (size + 2).pow(2)];

    let mut rolls = 0;

    loop {
        for yo in 1..sizep {
            let ym = yo - 1;
            let yp = yo + 1;
            for xo in 1..sizep {
                let xm = xo - 1;
                let xp = xo + 1;

                unsafe {
                    let was = *world.get_unchecked(pos(xo, yo)) == 1;
                    let neighbours = world.get_unchecked(pos(xm, ym))
                        + world.get_unchecked(pos(xo, ym))
                        + world.get_unchecked(pos(xp, ym))
                        + world.get_unchecked(pos(xm, yo))
                        + world.get_unchecked(pos(xp, yo))
                        + world.get_unchecked(pos(xm, yp))
                        + world.get_unchecked(pos(xo, yp))
                        + world.get_unchecked(pos(xp, yp));
                    *new_world.get_unchecked_mut(pos(xo, yo)) =
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

        if !part_2 || world == new_world {
            break;
        }

        swap(&mut world, &mut new_world);
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

    let part_1 = generations(input.clone(), size, false);
    println!("Part 1: {}", part_1);

    let part_2 = generations(input.clone(), size, true);
    println!("Part 2: {}", part_2);
}
