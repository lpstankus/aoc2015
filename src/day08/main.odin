package main

import "core:fmt"
import "core:strings"

main :: proc() {
	example := #load("example.txt")
	input := #load("input.txt")
	defer free_all()

	fmt.println(">> example:")
	part1, part2 := solve(example)
	fmt.println("part 1:", part1)
	fmt.println("part 2:", part2)

	fmt.println(">> input:")
	part1, part2 = solve(input)
	fmt.println("part 1:", part1)
	fmt.println("part 2:", part2)
}

solve :: proc(input: []u8) -> (part1, part2: int) {
	str := string(input)
	for row in strings.split_lines_iterator(&str) {
		part1 += len(row) - compressed_len(row)
		part2 += encoded_len(row) - len(row)
	}
	return
}

compressed_len :: proc(row: string) -> (ans: int) {
	ans = len(row)
	for i := 0; i < len(row); i += 1 {
		switch row[i] {
		case '"':
			ans -= 1
		case '\\':
			switch row[i + 1] {
			case 'x':
				ans -= 3
				i += 3
			case:
				ans -= 1
				i += 1
			}
		}
	}
	return
}

encoded_len :: proc(row: string) -> (ans: int) {
	ans = len(row) + 2
	for i := 0; i < len(row); i += 1 {
		switch row[i] {
		case '"', '\\':
			ans += 1
		}
	}
	return
}

