package main

import "core:fmt"
import "core:strconv"
import "core:strings"

Box :: struct {
	l, w, h: int,
}

main :: proc() {
	example := parse_input(#load("example.txt"))
	input := parse_input(#load("input.txt"))
	defer free_all()

	fmt.println(">> example:")
	fmt.println("part 1:", part1(example[:]))
	fmt.println("part 2:", part2(example[:]))

	fmt.println(">> input:")
	fmt.println("part 1:", part1(input[:]))
	fmt.println("part 2:", part2(input[:]))
}

parse_input :: proc(raw: []u8) -> [dynamic]Box {
	boxes: [dynamic]Box
	str := string(raw)
	for line in strings.split_lines_iterator(&str) {
		dim := strings.split(line, "x")
		defer delete(dim)
		append(
			&boxes,
			Box {
				strconv.parse_int(dim[0]) or_else panic("invalid input"),
				strconv.parse_int(dim[1]) or_else panic("invalid input"),
				strconv.parse_int(dim[2]) or_else panic("invalid input"),
			},
		)
	}
	return boxes
}

part1 :: proc(boxes: []Box) -> int {
	ans := 0
	for box in boxes {
		using box
		surface := 2 * l * w + 2 * w * h + 2 * h * l
		slack := 0
		switch {
		case l <= h && w <= h:
			slack = l * w
		case w <= l && h <= l:
			slack = h * w
		case l <= w && h <= w:
			slack = l * h
		}
		ans += surface + slack
	}
	return ans
}

part2 :: proc(boxes: []Box) -> int {
	ans := 0
	for box in boxes {
		using box
		wrap := 0
		switch {
		case l <= h && w <= h:
			wrap = l + l + w + w
		case w <= l && h <= l:
			wrap = h + h + w + w
		case l <= w && h <= w:
			wrap = l + l + h + h
		}
		ribbon := l * w * h
		ans += wrap + ribbon
	}
	return ans
}

