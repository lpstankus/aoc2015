package day03

import "core:crypto/legacy/md5"
import "core:fmt"

main :: proc() {
	example1 := #load("example1.txt")
	example2 := #load("example2.txt")
	input := #load("input.txt")
	defer free_all()

	fmt.println(">> example 1:")
	fmt.println("part 1:", solve(example1))

	fmt.println(">> example 2:")
	fmt.println("part 1:", solve(example2))

	fmt.println(">> input:")
	fmt.println("part 1:", solve(input))
	// fmt.println("part 2:", solve(input, 6)) // ...super slow, better to solve it in python
}

solve :: proc(input: []u8, leading := 5) -> int {
	key: [256]u8
	data: [32]u8
	for i := 0;; i += 1 {
		str := fmt.bprintf(key[:], "%s%d", input[:len(input) - 1], i)
		hash(transmute([]u8)str, data[:])

		loop: for l, j := 0, 0; l < leading; j += 1 {
			switch {
			case data[j] == 0:
				l += 2
			case data[j] < 16:
				l += 1
				if l == leading do return i
				break loop
			case:
				break loop
			}
		}
	}
}

hash :: proc(key, data: []u8) -> []u8 {
	ctx: md5.Context
	md5.init(&ctx)
	md5.update(&ctx, key)
	md5.final(&ctx, data)
	return data
}

