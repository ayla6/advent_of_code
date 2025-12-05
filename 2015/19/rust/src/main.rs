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

    let medicine_mol: Vec<String> = {
        let mut mol = Vec::new();
        input.last().unwrap().chars().for_each(|letter| {
            if letter.is_lowercase() {
                mol.push(format!("{}{}", mol.last().unwrap(), letter));
            } else {
                mol.push(format!("{}", letter))
            }
        });
        mol
    };
    println!("{:?}", medicine_mol);

    // part 1
    {
        let mol_len = medicine_mol.len();
        let mut possibilities: HashSet<String> = HashSet::new();
        for (k, element) in medicine_mol.iter().enumerate() {
            let of_element = combinations.get(element);

            match of_element {
                Some(of_element) => of_element.iter().for_each(|new_element| {
                    possibilities.insert(format!(
                        "{}{}{}",
                        medicine_mol[0..k].join(""),
                        new_element,
                        medicine_mol[k + 1..mol_len].join("")
                    ));
                }),
                _ => {}
            }
        }
        println!("Part 1: {}", possibilities.len())
    }
}
