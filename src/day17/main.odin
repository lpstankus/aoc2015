package main

import "core:fmt"
import "core:strconv"
import "core:strings"

counts := make(map[int]int)

main :: proc() {
	example := parse_input(#load("example.txt"))
	input := parse_input(#load("input.txt"))
	defer free_all()

	clear(&counts)
	fmt.println(">> example:")
	fmt.println("part 1:", part1(example, 25))
	fmt.println("part 2:", part2())

	clear(&counts)
	fmt.println(">> input:")
	fmt.println("part 1:", part1(input, 150))
	fmt.println("part 2:", part2())
}

parse_input :: proc(raw: []u8) -> (ret: [dynamic]int) {
	ret = make([dynamic]int)
	str := string(raw)
	for line in strings.split_lines_iterator(&str) {
		num := strconv.parse_int(line) or_else panic("UWU")
		append(&ret, num)
	}
	return
}

part1 :: proc(buckets: [dynamic]int, target: int) -> int {
	return fill(buckets[:], target, 0, 0)
}

part2 :: proc() -> (ans: int) {
	key := max(int)
	for k, v in counts {
		if k < key {
			key = k
			ans = v
		}
	}
	return
}

fill :: proc(buckets: []int, target, total, used: int) -> (ans: int) {
	if total > target do return 0
	if total == target {
		counts[used] += 1
		return 1
	}
	for buck, i in buckets {
		ans += fill(buckets[i + 1:], target, total + buck, used + 1)
	}
	return
}

