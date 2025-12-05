use std::collections::{HashMap, HashSet};

fn main() {
    let input = include_str!("../../input.txt");
    let input: Vec<&str> = input.trim().split("\n").collect();

    let combinations: HashMap<String, Vec<String>> = {
        let mut combinations = HashMap::new();
        input[..input.len() - 2].iter().for_each(|v| {
            let v: Vec<&str> = v.split(" ").collect();
            match v[..] {
                [original, "=>", target] => {
                    let entry = combinations
                        .entry(original.to_string())
                        .or_insert(Vec::with_capacity(1));
                    entry.push(target.to_string());
                }
                _ => panic!("{:?}", v),
            }
        });
        combinations
    };

    let medicine_mol = input.last().unwrap();

    // part 1
    {
        let mol_len = medicine_mol.len();
        let mut possibilities: HashSet<String> = HashSet::new();
        for i in 0..mol_len {
            let (a, b) = medicine_mol.split_at(i);
            combinations.iter().for_each(|(from, to)| {
                to.iter().for_each(|to| {
                    possibilities.insert(format!(
                        "{}{}",
                        a,
                        b.replacen(from, to, 1)
                    ));
                })
            });
        }
        println!("Part 1: {}", possibilities.len() - 1)
    }
}
