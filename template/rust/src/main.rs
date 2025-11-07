fn main() {
    let input: String = match std::fs::read_to_string("../input.txt") {
        Ok(input) => input,
        _ => panic!("invalid input!!!"),
    };

    println!("{}", &input);
}
