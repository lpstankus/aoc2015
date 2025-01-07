package main

import "core:fmt"
import "core:strings"

main :: proc() {
	example := #load("example.txt")
	input := #load("input.txt")
	defer free_all()

	fmt.println(">> example:")
	fmt.println("part 1:", solve(example, 4))

	fmt.println(">> input:")
	fmt.println("part 1:", solve(input, 40))
	fmt.println("part 2:", solve(input, 50))
}

solve :: proc(input: []u8, steps: int) -> int {
	wr_buf := make([dynamic]uint)
	rd_buf := make([dynamic]uint)

	for char in input {
		if char == '\n' do continue
		append(&rd_buf, uint(char - '0'))
	}

	for _ in 0 ..< steps {
		streak: uint
		streak_num := rd_buf[0]
		for num in rd_buf {
			switch num {
			case streak_num:
				streak += 1
			case:
				append(&wr_buf, streak, streak_num)
				streak_num = num
				streak = 1
			}
		}
		append(&wr_buf, streak, streak_num)

		resize(&rd_buf, len(wr_buf))
		copy(rd_buf[:], wr_buf[:])
		clear(&wr_buf)
	}

	return len(rd_buf)
}

