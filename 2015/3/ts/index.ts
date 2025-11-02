type Direction = "^" | "v" | "<" | ">";
interface Location {
	x: number;
	y: number;
}
type World = Map<string, number>;
type Turn = "Santa" | "Robo";

function giveGift(world: World, location: Location) {
	const locationString = JSON.stringify(location);
	return world.set(locationString, (world.get(locationString) ?? 0) + 1);
}

function moveTo(location: Location, direction: Direction) {
	if (direction === "^") {
		location.y -= 1;
	} else if (direction === "v") {
		location.y += 1;
	} else if (direction === "<") {
		location.x -= 1;
	} else if (direction === ">") {
		location.x += 1;
	}
	return location;
}

const input = (await Bun.file("../input.txt").text())
	.trim()
	.split("") as Direction[];

// the gleam one is so much better...
// part 1
{
	const location: Location = { x: 0, y: 0 };
	const world: World = new Map();
	input.forEach((direction) => {
		giveGift(world, location);
		moveTo(location, direction);
	});
	console.log(world.size);
}

// part 2
{
	const santa_location: Location = { x: 0, y: 0 };
	const robo_location: Location = { x: 0, y: 0 };
	const world: World = new Map();
	let turn: Turn = "Santa";
	const location = () => (turn === "Santa" ? santa_location : robo_location);
	input.forEach((direction) => {
		giveGift(world, location());
		moveTo(location(), direction);
		turn = turn === "Santa" ? "Robo" : "Santa";
	});
	console.log(world.size);
}
