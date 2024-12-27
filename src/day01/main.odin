package main

import "core:fmt"

main :: proc() {
	example1 := #load("example1.txt")
	example2 := #load("example2.txt")
	input := #load("input.txt")

	fmt.println(">> example 1:")
	fmt.println("part 1:", solve(example1))
	fmt.println("part 1:", solve(example1, true))

	fmt.println(">> example 2:")
	fmt.println("part 1:", solve(example2))
	fmt.println("part 2:", solve(example2, true))

	fmt.println(">> input:")
	fmt.println("part 1:", solve(input))
	fmt.println("part 2:", solve(input, true))
}

solve :: proc(input: []u8, stop_at_under: bool = false) -> int {
	stack := 0
	for char, i in input {
		switch char {
		case '(':
			stack += 1
		case ')':
			stack -= 1
			if stop_at_under && stack < 0 do return i + 1
		case '\n':
			return stack
		case:
			panic("invalid input char")
		}
	}
	return stack
}

