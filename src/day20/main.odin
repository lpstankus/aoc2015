package main

import "core:fmt"

main :: proc() {
	defer free_all()

	fmt.println(">> example:")
	fmt.println("part 1:", part1(70))

	fmt.println(">> input:")
	fmt.println("part 1:", part1(34000000))
	fmt.println("part 2:", part2(34000000))
}

part1 :: proc(input: int) -> int {
	target := input / 10

	houses := make([]int, target)
	ans := target
	for i := 1; i < target; i += 1 {
		for j := i; j < target; j += i {
			houses[j] += i
			if houses[j] >= target && j < ans do ans = j
		}
	}
	return ans
}

part2 :: proc(input: int) -> int {
	cap := input / 10

	houses := make([]int, cap)
	ans := input

	for i := 1; i < cap; i += 1 {
		visits: int
		for j := i; j < cap; j += i {
			houses[j] += i * 11
			if houses[j] >= input && j < ans do ans = j

			visits += 1
			if visits == 50 do break
		}
	}
	return ans
}

