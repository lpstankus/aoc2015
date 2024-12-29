package main

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

SIZE :: 1000
b_grid: [SIZE][SIZE]bool
i_grid: [SIZE][SIZE]int

Rect :: struct {
	anchor, len: [2]int,
}

main :: proc() {
	example := #load("example.txt")
	input := #load("input.txt")
	defer free_all()

	fmt.println(">> example:")
	fmt.println("part 1:", part1(example))
	fmt.println("part 2:", part2(example))

	b_grid = {}
	i_grid = {}

	fmt.println(">> input:")
	fmt.println("part 1:", part1(input))
	fmt.println("part 2:", part2(input))
}

part1 :: proc(input: []u8) -> int {
	str := string(input)
	for line in strings.split_lines_iterator(&str) {
		switch {
		case strings.starts_with(line, "toggle "):
			rect := parse_range(line[7:])
			toggle(rect)
		case strings.starts_with(line, "turn on "):
			rect := parse_range(line[8:])
			set(rect, true)
		case strings.starts_with(line, "turn off "):
			rect := parse_range(line[9:])
			set(rect, false)
		case:
			panic(fmt.aprintln("invalid op in line:", line))
		}
	}

	ans: int
	for row in b_grid {
		for light in row {
			if light do ans += 1
		}
	}
	return ans
}

part2 :: proc(input: []u8) -> (ans: int) {
	str := string(input)
	for line in strings.split_lines_iterator(&str) {
		switch {
		case strings.starts_with(line, "toggle "):
			rect := parse_range(line[7:])
			add(rect, 2)
		case strings.starts_with(line, "turn on "):
			rect := parse_range(line[8:])
			add(rect, 1)
		case strings.starts_with(line, "turn off "):
			rect := parse_range(line[9:])
			add(rect, -1)
		case:
			panic(fmt.aprintln("invalid op in line:", line))
		}
	}

	for row in i_grid {
		for light in row {
			ans += light
		}
	}
	return
}

parse_range :: proc(input: string) -> Rect {
	splits := strings.split_multi(input, []string{",", " "})
	x0, _ := strconv.parse_int(splits[0])
	y0, _ := strconv.parse_int(splits[1])
	x1, _ := strconv.parse_int(splits[3])
	y1, _ := strconv.parse_int(splits[4])
	return Rect {
		anchor = {math.min(x0, x1), math.min(y0, y1)},
		len = {math.abs(x1 - x0) + 1, math.abs(y1 - y0) + 1},
	}
}

toggle :: proc(using rect: Rect) {
	for i in anchor.y ..< anchor.y + len.y {
		for j in anchor.x ..< anchor.x + len.x {
			b_grid[i][j] = !b_grid[i][j]
		}
	}
}

set :: proc(using rect: Rect, val: bool) {
	for i in anchor.y ..< anchor.y + len.y {
		for j in anchor.x ..< anchor.x + len.x {
			b_grid[i][j] = val
		}
	}
}

add :: proc(using rect: Rect, val: int) {
	for i in anchor.y ..< anchor.y + len.y {
		for j in anchor.x ..< anchor.x + len.x {
			i_grid[i][j] += val
			if i_grid[i][j] < 0 do i_grid[i][j] = 0
		}
	}
}

