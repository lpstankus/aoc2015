package main

import "core:encoding/json"
import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	example := #load("example.txt", string)
	input := #load("input.txt", string)
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

solve :: proc(input: string) -> (part1, part2: int) {
	parsed, err := json.parse(transmute([]u8)input, parse_integers = true)
	if err != nil do panic("UWU")
	return traverse(parsed)
}

traverse :: proc(input: json.Value) -> (part1, part2: int) {
	red: bool
	obj, ok := input.(json.Object)
	if ok do for _, val in obj {
		v, ok := val.(json.String)
		if ok && v == "red" do red = true
	}

	#partial switch value in input {
	case json.Object:
		for _, v in value {
			p1, p2 := traverse(v)
			part1 += p1
			if !red do part2 += p2
		}
	case json.Array:
		for v in value {
			p1, p2 := traverse(v)
			part1 += p1
			part2 += p2
		}
	case json.Integer:
		part1, part2 = int(value), int(value)
	}
	return
}

