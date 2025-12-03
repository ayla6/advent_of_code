fn solve(input: &Vec<Vec<u32>>, digits: usize) {
    input.iter().fold(0, |acc, bank| {
        let n = (0..digits).fold((0, bank), |(number, bank), i| {
            let max = bank[0..bank.len() - i]
                .iter()
                .max()
                .unwrap_or(bank.last().unwrap());

            return (number * 10 + max, bank[0..bank.len() - max_loc - 1]);
        });
        acc + n
    })
}

fn main() {
    let input: Vec<Vec<u32>> = include_str!("../../input.txt")
        .trim()
        .split("\n")
        .map(|bank| bank.chars().map(|s| s.to_digit(10).unwrap()).collect())
        .collect();
}
