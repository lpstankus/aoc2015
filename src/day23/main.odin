package main

import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	defer free_all()

	example := #load("example.txt")
	input := #load("input.txt")

	fmt.println(">> example:")
	fmt.println("part 1:", part1(example))
	fmt.println("part 2:", part2(example))

	fmt.println(">> input:")
	fmt.println("part 1:", part1(input, true))
	fmt.println("part 2:", part2(input, true))
}

part1 :: proc(raw: []u8, input: bool = false) -> int {
	a, b := simulate(string(raw))
	return int(b) if input else int(a)
}

part2 :: proc(raw: []u8, input: bool = false) -> int {
	a, b := simulate(string(raw), start_a = 1)
	return int(b) if input else int(a)
}


simulate :: proc(program: string, start_a: uint = 0) -> (a, b: uint) {
	lines := strings.split_lines(program)

	a = start_a

	for pc := 0; pc < len(lines); pc += 1 {
		if len(lines[pc]) == 0 do break

		args := strings.split(lines[pc], " ")

		switch args[0] {
		case "hlf":
			switch args[1] {
			case "a":
				a /= 2
			case "b":
				b /= 2
			case:
				panic("invalid reg")
			}
		case "tpl":
			switch args[1] {
			case "a":
				a *= 3
			case "b":
				b *= 3
			case:
				panic("invalid reg")
			}
		case "inc":
			switch args[1] {
			case "a":
				a += 1
			case "b":
				b += 1
			case:
				panic("invalid reg")
			}
		case "jmp":
			off := strconv.parse_int(args[1]) or_else panic("UE")
			pc += off - 1
		case "jie":
			switch args[1][:1] {
			case "a":
				if a % 2 != 0 do continue
			case "b":
				if b % 2 != 0 do continue
			case:
				panic("invalid reg")
			}
			off := strconv.parse_int(args[2]) or_else panic("UE")
			pc += off - 1
		case "jio":
			switch args[1][:1] {
			case "a":
				if a != 1 do continue
			case "b":
				if b != 1 do continue
			case:
				panic("invalid reg")
			}
			off := strconv.parse_int(args[2]) or_else panic("UE")
			pc += off - 1
		case:
			panic("invalid instr")
		}
	}

	return
}

