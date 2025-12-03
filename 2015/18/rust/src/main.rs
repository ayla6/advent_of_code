use std::mem::swap;

fn generations(times: u32, mut world: Vec<u8>, size: usize, stuck: bool) -> Vec<u8> {
    #[inline]
    fn pos(x: usize, y: usize, size: usize) -> usize {
        y * (size + 2) + x
    }

    #[inline]
    fn get_at(world: &Vec<u8>, size: usize, x: usize, y: usize) -> u8 {
        // this is in known bounds
        unsafe { *world.get_unchecked(pos(x, y, size)) }
    }

    let sizep = size + 1;

    let mut new_world = vec![0_u8; (size + 2).pow(2)];

    if stuck {
        world[pos(1, 1, size)] = 1;
        world[pos(size, 1, size)] = 1;
        world[pos(1, size, size)] = 1;
        world[pos(size, size, size)] = 1;
    }

    for _ in 0..times {
        for yo in 1..sizep {
            let ym = yo - 1;
            let yp = yo + 1;
            for xo in 1..sizep {
                let xm = xo - 1;
                let xp = xo + 1;

                let was = get_at(&world, size, xo, yo) == 1;
                let neighbours = get_at(&world, size, xm, ym)
                    + get_at(&world, size, xo, ym)
                    + get_at(&world, size, xp, ym)
                    + get_at(&world, size, xm, yo)
                    + get_at(&world, size, xp, yo)
                    + get_at(&world, size, xm, yp)
                    + get_at(&world, size, xo, yp)
                    + get_at(&world, size, xp, yp);
                new_world[pos(xo, yo, size)] = (neighbours == 3 || (neighbours == 2 && was)) as u8;
            }
        }

        swap(&mut world, &mut new_world);

        // i hate the duplication here :(
        if stuck {
            world[pos(1, 1, size)] = 1;
            world[pos(size, 1, size)] = 1;
            world[pos(1, size, size)] = 1;
            world[pos(size, size, size)] = 1;
        }
    }
    world
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
                .map(|v| (v == '#') as u8)
                .collect()
        })
        .flatten()
        .collect();

    let part_1 = generations(100, input.clone(), size, false)
        .iter()
        .filter(|v| **v == 1)
        .count();
    println!("Part 1: {}", part_1);

    let part_2 = generations(100, input.clone(), size, true)
        .iter()
        .filter(|v| **v == 1)
        .count();
    println!("Part 2: {}", part_2);
}
