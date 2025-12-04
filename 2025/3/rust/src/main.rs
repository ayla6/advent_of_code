// fun fact for this version, my biggest bug was integer overflow when i was using u32 because im not accustumed to this shit

fn solve(input: &Vec<Vec<u64>>, digits: usize) -> u64 {
    input.iter().fold(0, |acc, bank| {
        let bank_len = bank.len();
        let (n, _) = (0..digits).rfold((0, 0), |(number, bank_index), i| {
            let (loc, max) = bank[bank_index..bank_len - i]
                .iter()
                .enumerate()
                .reduce(
                    |(maxi, max), (i, n)| {
                        if n > max { (i, n) } else { (maxi, max) }
                    },
                )
                // #yup #i'm unwrapping #idontwannausefold
                .unwrap();

            ((number * 10) + max, bank_index + loc + 1)
        });
        acc + n
    })
}

fn main() {
    let input: Vec<Vec<u64>> = include_str!("../../input.txt")
        .trim()
        .split("\n")
        .map(|bank| {
            bank.chars()
                .map(|s| s.to_digit(10).unwrap() as u64)
                .collect()
        })
        .collect();

    println!("Part 1: {}", solve(&input, 2));
    println!("Part 2: {}", solve(&input, 12));
}
