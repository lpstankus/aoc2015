package main

import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	input := parse_input(#load("input.txt"))
	defer free_all()

	fmt.println(">> input:")
	fmt.println("part 1:", part1(input))
	fmt.println("part 2:", part2(input))
}

parse_input :: proc(raw: []u8) -> (ret: [dynamic]map[string]int) {
	ret = make([dynamic]map[string]int)
	str := string(raw)
	for row in strings.split_lines_iterator(&str) {
		splits := strings.split_multi(row, {",", ":", " "})
		sue := make(map[string]int)
		for i := 3; i < len(splits); i += 4 {
			sue[splits[i]] = strconv.parse_int(splits[i + 2]) or_else panic("A")
		}
		append(&ret, sue)
	}
	return
}

part1 :: proc(input: [dynamic]map[string]int) -> int {
	for sue, i in input {
		matched := true
		for key, val in sue {
			switch key {
			case "children":
				if val != 3 do matched = false
			case "cats":
				if val != 7 do matched = false
			case "samoyeds":
				if val != 2 do matched = false
			case "pomeranians":
				if val != 2 do matched = false
			case "akitas":
				if val != 0 do matched = false
			case "vizslas":
				if val != 0 do matched = false
			case "goldfish":
				if val != 5 do matched = false
			case "trees":
				if val != 3 do matched = false
			case "cars":
				if val != 2 do matched = false
			case "perfumes":
				if val != 1 do matched = false
			case:
				panic(key)
			}
		}
		if matched do return i + 1
	}
	return -1
}

part2 :: proc(input: [dynamic]map[string]int) -> int {
	for sue, i in input {
		matched := true
		for key, val in sue {
			switch key {
			case "children":
				if val != 3 do matched = false
			case "cats":
				if val <= 7 do matched = false
			case "samoyeds":
				if val != 2 do matched = false
			case "pomeranians":
				if val >= 2 do matched = false
			case "akitas":
				if val != 0 do matched = false
			case "vizslas":
				if val != 0 do matched = false
			case "goldfish":
				if val >= 5 do matched = false
			case "trees":
				if val <= 3 do matched = false
			case "cars":
				if val != 2 do matched = false
			case "perfumes":
				if val != 1 do matched = false
			case:
				panic(key)
			}
		}
		if matched do return i + 1
	}
	return -1
}

