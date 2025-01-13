package main

import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	defer free_all()

	example := parse_input(#load("example.txt"))
	input := parse_input(#load("input.txt"))

	fmt.println(">> example:")
	fmt.println("part 1:", solve(example))
	fmt.println("part 2:", solve(example, 4))

	fmt.println(">> input:")
	fmt.println("part 1:", solve(input))
	fmt.println("part 2:", solve(input, 4))
}

parse_input :: proc(raw: []u8) -> []int {
	out := make([dynamic]int)
	str := string(raw)
	for line in strings.split_lines_iterator(&str) {
		if len(line) == 0 do break
		weight := strconv.parse_int(line) or_else panic("UWU")
		append(&out, weight)
	}
	return out[:]
}

solve :: proc(weights: []int, ngroups: int = 3) -> int {
	sum: int
	for w in weights do sum += w

	if sum % ngroups != 0 do panic("UE")
	target := sum / ngroups

	groups := make([dynamic][]int)
	{ 	// find groups with smallest size that sum up to target
		stack := make([dynamic]int)
		for length := 1;; length += 1 {
			counts := find_groups(&groups, &stack, weights, target, length)
			if counts != 0 do break
		}
	}

	quantum := max(int)
	for group in groups {
		cur := 1
		for w in group do cur *= w
		quantum = min(quantum, cur)
	}
	return quantum
}

find_groups :: proc(
	groups: ^[dynamic][]int,
	stack: ^[dynamic]int,
	weights: []int,
	rem_sum, rem_sz: int,
	start_i: int = 0,
) -> int {
	if rem_sz <= 0 {
		if rem_sum != 0 do return 0

		slice := make([]int, len(stack))
		copy(slice[:], stack[:])
		append(groups, slice)
		return 1
	}

	count := 0
	for i := start_i; i < len(weights); i += 1 {
		w: int
		w, weights[i] = weights[i], 0
		defer weights[i] = w

		if w == 0 do continue
		if rem_sum - w < 0 do continue

		append(stack, w)
		defer assert(pop(stack) == w)

		count += find_groups(
			groups,
			stack,
			weights,
			rem_sum - w,
			rem_sz - 1,
			start_i = i + 1,
		)

	}
	return count
}

