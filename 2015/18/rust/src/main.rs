use std::{iter::once, mem::swap};

fn generations(times: u32, mut world: Vec<u8>, size: usize, stuck: bool) -> Vec<u8> {
    #[inline]
    fn get_at(world: &Vec<u8>, size: usize, x: usize, y: usize) -> u8 {
        // benefits from the integer overflow to simplify code
        if x >= size || y >= size {
            return 0;
        };
        // this is in known bounds
        unsafe { *world.get_unchecked(y * size + x) }
    }

    let mut new_world = vec![0_u8; size * size];
    let sizem = size - 1;
    if stuck {
        world[0] = 1;
        world[sizem] = 1;
        world[(size * size) - 1] = 1;
        world[size * sizem] = 1;
    }

    for _ in 0..times {
        for yo in 1..=size {
            let ym = yo - 1;
            let yp = yo + 1;
            for xo in 1..=size {
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
                new_world[yo * size + xo] = (neighbours == 3 || (neighbours == 2 && was)) as u8;
            }
        }

        swap(&mut world, &mut new_world);

        // i hate the duplication here :(
        if stuck {
            world[0] = 1;
            world[sizem] = 1;
            world[(size * size) - 1] = 1;
            world[size * sizem] = 1;
        }
    }
    world
}

fn main() {
    let input = include_str!("../../input.txt").trim();
    let size = input.split_once("\n").expect("invalid input").0.len();
    let input: Vec<u8> = once(".".repeat(size))
        .chain(input.split("\n"))
        .chain(".".repeat(size))
        .map(|line| {
            once(0)
                .chain(line.chars().map(|v| (v == '#') as u8))
                .chain(once(0))
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
