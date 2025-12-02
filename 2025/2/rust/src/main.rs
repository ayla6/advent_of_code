struct Range {
    start: u64,
    end: u64,
}

fn main() {
    let input: Vec<Range> = include_str!("../../input.txt")
        .trim()
        .split(",")
        .map(|v| {
            let range = v.split_once("-");
            match range {
                Some((start, end)) => Range {
                    start: start.parse().expect("invalid number"),
                    end: end.parse().expect("invalid number"),
                },
                _ => panic!("bad input!"),
            }
        })
        .collect();

    let powers_of_ten: Vec<u64> = (0..10).map(|i| 10_u64.pow(i)).collect();

    let part_1 = input.iter().fold(0_u64, |acc, v| {
        (v.start..=v.end).fold(acc, |acc, n| {
            if n <= 10 {
                return acc;
            }
            let len = (n.ilog10() + 1) as usize;
            if len % 2 == 1 {
                return acc;
            }
            let pow = powers_of_ten.get(len / 2).unwrap();
            if n / pow == n % pow {
                return acc + n;
            }
            acc
        })
    });
    println!("{}", part_1);

    let part_2 = input.iter().fold(0_u64, |acc, v| {
        (v.start..=v.end).fold(acc, |acc, n| {
            if n <= 10 {
                return acc;
            }
            let len = (n.ilog10() + 1) as usize;
            match (1..=len / 2).rfind(|clen| {
                let num = n % powers_of_ten.get(*clen).unwrap();
                let res = (0..len / clen)
                    .fold(0, |acc, i| acc + num * powers_of_ten.get(i * clen).unwrap());
                res == n
            }) {
                Some(_) => acc + n,
                _ => acc,
            }
        })
    });
    println!("{}", part_2);
}
