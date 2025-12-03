use std::mem::swap;

#[inline]
fn get_at(world: &Vec<Vec<bool>>, size: usize, x: isize, y: isize) -> u8 {
    let isize = size as isize;
    if x == isize || x == -1 || y == isize || y == -1 {
        return 0;
    };
    if *world
        .get(y as usize)
        .expect("invalid position")
        .get(x as usize)
        .expect("invalid position")
    {
        1
    } else {
        0
    }
}

#[inline]
fn get_at_bool(world: &Vec<Vec<bool>>, x: usize, y: usize) -> bool {
    *world
        .get(y)
        .expect("invalid position")
        .get(x)
        .expect("invalid position")
}

fn generations(times: u32, mut world: Vec<Vec<bool>>, size: usize, stuck: bool) -> Vec<Vec<bool>> {
    let mut new_world = vec![vec![false; size]; size];
    if stuck {
        let sizem = size - 1;
        world[0][0] = true;
        world[0][sizem] = true;
        world[sizem][0] = true;
        world[sizem][sizem] = true;
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

                let was = get_at_bool(&world, x, y);
                let neighbours = get_at(&world, size, xm, ym)
                    + get_at(&world, size, xo, ym)
                    + get_at(&world, size, xp, ym)
                    + get_at(&world, size, xm, yo)
                    + get_at(&world, size, xp, yo)
                    + get_at(&world, size, xm, yp)
                    + get_at(&world, size, xo, yp)
                    + get_at(&world, size, xp, yp);
                new_world[y][x] = neighbours == 3 || (neighbours == 2 && was);
            }
        }

        swap(&mut world, &mut new_world);

        // i hate the duplication here :(
        if stuck {
            let sizem = size - 1;
            world[0][0] = true;
            world[0][sizem] = true;
            world[sizem][0] = true;
            world[sizem][sizem] = true;
        }
    }
    world
}

fn main() {
    let input = include_str!("../../input.txt").trim();
    let size = input.split_once("\n").expect("invalid input").0.len();
    let input: Vec<Vec<bool>> = input
        .split("\n")
        .map(|line| line.chars().map(|v| v == '#').collect())
        .collect();

    let part_1 = generations(100, input.clone(), size, false)
        .iter()
        .flatten()
        .filter(|v| **v)
        .count();
    println!("Part 1: {}", part_1);

    let part_2 = generations(100, input.clone(), size, true)
        .iter()
        .flatten()
        .filter(|v| **v)
        .count();
    println!("Part 2: {}", part_2);
}
