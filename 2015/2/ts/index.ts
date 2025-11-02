const input = (await Bun.file("../input.json").json()) as [
	number,
	number,
	number,
][];

// part 1
console.log(
	input.reduce((prev, cur) => {
		const sides = [cur[0] * cur[1], cur[1] * cur[2], cur[0] * cur[2]] as const;
		return (
			prev + (2 * sides[0] + 2 * sides[1] + 2 * sides[2] + Math.min(...sides))
		);
	}, 0),
);

// part 2
console.log(
	input.reduce((prev, cur) => {
		const smallestPerimeter = Math.min(
			2 * cur[0] + 2 * cur[1],
			2 * cur[1] + 2 * cur[2],
			2 * cur[2] + 2 * cur[0],
		);
		return prev + (smallestPerimeter + cur[0] * cur[1] * cur[2]);
	}, 0),
);
