use std::mem::swap;

#[inline]
fn get_at(world: &Vec<bool>, size: usize, x: usize, y: usize) -> u8 {
    // benefits from the integer overflow to simplify code
    if x >= size || y >= size {
        return 0;
    };
    // this is in known bounds
    unsafe { *world.get_unchecked(y * size + x) as u8 }
}

#[inline]
fn get_at_bool(world: &Vec<bool>, size: usize, x: usize, y: usize) -> bool {
    // this is in known bounds
    unsafe { *world.get_unchecked(y * size + x) }
}

fn generations(times: u32, mut world: Vec<bool>, size: usize, stuck: bool) -> Vec<bool> {
    let mut new_world = vec![false; size * size];
    let sizem = size - 1;
    if stuck {
        world[0] = true;
        world[sizem] = true;
        world[(size * size) - 1] = true;
        world[size * sizem] = true;
    }

    for _ in 0..times {
        for yo in 0..size {
            let ym = yo.wrapping_sub(1);
            let yp = yo + 1;
            for xo in 0..size {
                let xm = xo.wrapping_sub(1);
                let xp = xo + 1;

                let was = get_at_bool(&world, size, xo, yo);
                let neighbours = get_at(&world, size, xm, ym)
                    + get_at(&world, size, xo, ym)
                    + get_at(&world, size, xp, ym)
                    + get_at(&world, size, xm, yo)
                    + get_at(&world, size, xp, yo)
                    + get_at(&world, size, xm, yp)
                    + get_at(&world, size, xo, yp)
                    + get_at(&world, size, xp, yp);
                new_world[yo * size + xo] = neighbours == 3 || (neighbours == 2 && was);
            }
        }

        swap(&mut world, &mut new_world);

        // i hate the duplication here :(
        if stuck {
            world[0] = true;
            world[sizem] = true;
            world[(size * size) - 1] = true;
            world[size * sizem] = true;
        }
    }
    world
}

fn main() {
    let input = include_str!("../../input.txt").trim();
    let size = input.split_once("\n").expect("invalid input").0.len();
    let input: Vec<bool> = input.replace("\n", "").chars().map(|v| v == '#').collect();

    let part_1 = generations(100, input.clone(), size, false)
        .iter()
        .filter(|v| **v)
        .count();
    println!("Part 1: {}", part_1);

    let part_2 = generations(100, input.clone(), size, true)
        .iter()
        .filter(|v| **v)
        .count();
    println!("Part 2: {}", part_2);
}
