use std::mem::swap;

#[inline]
fn get_at(world: &Vec<bool>, size: usize, x: isize, y: isize) -> u8 {
    let isize = size as isize;
    if x == isize || x == -1 || y == isize || y == -1 {
        return 0;
    };
    let (x, y) = (x as usize, y as usize);
    if *world.get(y * size + x).expect("invalid position") {
        1
    } else {
        0
    }
}

#[inline]
fn get_at_bool(world: &Vec<bool>, size: usize, x: usize, y: usize) -> bool {
    *world.get(y * size + x).expect("invalid position")
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
        for y in 0..size {
            for x in 0..size {
                let xo = x as isize;
                let yo = y as isize;
                let xm = xo - 1;
                let ym = yo - 1;
                let xp = xo + 1;
                let yp = yo + 1;

                let was = get_at_bool(&world, size, x, y);
                let neighbours = get_at(&world, size, xm, ym)
                    + get_at(&world, size, xo, ym)
                    + get_at(&world, size, xp, ym)
                    + get_at(&world, size, xm, yo)
                    + get_at(&world, size, xp, yo)
                    + get_at(&world, size, xm, yp)
                    + get_at(&world, size, xo, yp)
                    + get_at(&world, size, xp, yp);
                new_world[y * size + x] = neighbours == 3 || (neighbours == 2 && was);
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
