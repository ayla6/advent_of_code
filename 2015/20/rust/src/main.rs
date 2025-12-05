fn main() {
    let input: u64 = include_str!("../../input.txt")
        .trim()
        .parse()
        .expect("bad input");
    let input = input / 10;

    let mut highest_house = (0, 0);
    let mut house: u64 = 1;
    // while highest_house.1 < input {
    while house < 10 {
        let presents = if house % 2 == 0 {
            (1..house + 1).fold(0, |acc, elf| {
                if house % elf == 0 { acc + elf } else { acc }
            })
        } else {
            (1..house.div_ceil(2) + 1).fold(0, |acc, elf| {
                if house % (elf * 2) == 0 {
                    acc + elf
                } else {
                    acc
                }
            })
        };
        if presents > highest_house.1 {
            highest_house = (house, presents);
        }
        house += 1;
        println!("{} {}", house, presents);
    }

    println!("Part 1: {:?}", highest_house);
}
