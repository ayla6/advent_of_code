use md5::{Digest, Md5};

// just putting it here that the idea of analysing it as bytes instead of a string and of putting the main hasher outside the loop was gemini
fn find(input: &str, requires: usize) -> u32 {
    let mut i = 1;
    let div_ceiled = requires.div_ceil(2) - 1;
    let starts_with = &[0_u8].repeat(requires / 2);

    let mut hasher_main = Md5::new();
    hasher_main.update(input.as_bytes());

    loop {
        let mut hasher = hasher_main.clone();
        hasher.update(i.to_string().as_bytes());
        let result = hasher.finalize();
        if result[div_ceiled] < 16 && result.starts_with(starts_with) {
            return i;
        }
        i += 1;
    }
}

fn main() {
    let input =
        std::fs::read_to_string("../input.txt").expect("invalid input!!");
    let input = input.trim();

    let res = find(input, 5);
    println!("{}", &res);

    let res = find(input, 6);
    println!("{}", &res);
}
