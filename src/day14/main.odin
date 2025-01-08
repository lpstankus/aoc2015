package main

import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:time"

Reindeer :: struct {
	resting_time: int,
	running_time: int,
	countdown:    int,
	speed:        int,
	state:        enum {
		Running,
		Resting,
	},
	distance:     int,
	points:       int,
}

main :: proc() {
	example := parse_input(#load("example.txt"))
	input := parse_input(#load("input.txt"))
	defer free_all()

	part1, part2 := solve(example, 1000)
	fmt.println(">> example:")
	fmt.println("part 1:", part1)
	fmt.println("part 2:", part2)

	part1, part2 = solve(input, 2503)
	fmt.println(">> input:")
	fmt.println("part 1:", part1)
	fmt.println("part 2:", part2)
}

parse_input :: proc(raw: []u8) -> (ret: [dynamic]Reindeer) {
	ret = make([dynamic]Reindeer)
	str := string(raw)
	for row in strings.split_lines_iterator(&str) {
		splits := strings.split(row, " ")
		r := Reindeer {
			speed        = strconv.parse_int(splits[3]) or_else panic(""),
			countdown    = strconv.parse_int(splits[6]) or_else panic(""),
			running_time = strconv.parse_int(splits[6]) or_else panic(""),
			resting_time = strconv.parse_int(splits[13]) or_else panic(""),
		}
		append(&ret, r)
	}
	return
}

solve :: proc(input: [dynamic]Reindeer, steps: int) -> (distance, points: int) {
	for _ in 0 ..< steps {
		max_dist: int
		for &r in input {
			if r.state == .Running do r.distance += r.speed
			r.countdown -= 1
			if r.countdown <= 0 {
				switch r.state {
				case .Running:
					r.state = .Resting
					r.countdown = r.resting_time
				case .Resting:
					r.state = .Running
					r.countdown = r.running_time
				}
			}
			max_dist = max(max_dist, r.distance)
		}
		for &r in input do if r.distance == max_dist do r.points += 1
	}
	for r in input {
		distance = max(distance, r.distance)
		points = max(points, r.points)
	}
	return
}

