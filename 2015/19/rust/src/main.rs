struct Combination {
    original: String,
    target: String,
}

fn main() {
    let input: String = std::fs::read_to_string("../input.txt").expect("invalid input!!");
    let input: Vec<&str> = input.split("\n").collect();
    let combinations: Vec<Combination> = &input[..input.len() - 2].iter().map(|v| {
        let v: Vec<&str> = v.split(" ").collect();
        match v[..] {
            [original, _, target] => Combination {
                original: original.to_string(),
                target: target.to_string(),
            },
            _ => Combination {
                original: "".to_string(),
                target: "".to_string(),
            },
        }
    }).
}
