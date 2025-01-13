package main

import "core:fmt"

main :: proc() {
	defer free_all()

	fmt.println(">> input:")
	fmt.println("part 1:", generate_numbers())
}

generate_numbers :: proc() -> int {
	INIT :: 20151125

	prev := INIT
	outer: for i := 1;; i += 1 {
		for j in 0 ..= i {
			new_val := (prev * 252533) %% 33554393
			prev = new_val

			if (i - j) == 2980 && j == 3074 do return new_val
		}
	}
}

