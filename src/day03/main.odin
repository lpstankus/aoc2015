package day03

import "core:fmt"

Pos :: distinct [3]int

main :: proc() {
	example1 := #load("example1.txt")
	example2 := #load("example2.txt")
	input := #load("input.txt")
	defer free_all()

	fmt.println(">> example 1:")
	fmt.println("part 1:", solve(example1))
	fmt.println("part 2:", solve(example1, true))

	fmt.println(">> example 2:")
	fmt.println("part 1:", solve(example2))
	fmt.println("part 2:", solve(example2, true))

	fmt.println(">> input:")
	fmt.println("part 1:", solve(input))
	fmt.println("part 2:", solve(input, true))
}

solve :: proc(input: []u8, part2 := false) -> int {
	santa := Pos{}
	robot := Pos{}

	visited := make(map[Pos]bool)
	visited[santa] = true
	for c, i in input {
		switch (part2 && i % 2 == 0) {
		case false:
			santa += dir(c)
		case true:
			robot += dir(c)
		}

		visited[santa] = true
		visited[robot] = true
	}
	return len(visited)
}

dir :: proc(c: u8) -> Pos {
	pos := Pos{}
	switch (c) {
	case '<':
		pos.x -= 1
	case '>':
		pos.x += 1
	case '^':
		pos.y -= 1
	case 'v':
		pos.y += 1
	case '\n':
		break
	case:
		panic("UWU")
	}
	return pos
}

