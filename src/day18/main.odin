package main

import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	example := parse_input(#load("example.txt"), 6)
	input := parse_input(#load("input.txt"), 100)
	defer free_all()

	fmt.println(">> example:")
	fmt.println("part 1:", part1(example, 4))
	fmt.println("part 2:", part2(example, 5))

	fmt.println(">> input:")
	fmt.println("part 1:", part1(input, 100))
	fmt.println("part 2:", part2(input, 100))
}

parse_input :: proc(raw: []u8, $N: int) -> (lights: [N][N]bool) {
	i: int
	str := string(raw)
	for line in strings.split_lines_iterator(&str) {
		defer i += 1
		for c, j in line {
			switch c {
			case '.':
			case '#':
				lights[i][j] = true
			case:
				panic("UWU")
			}
		}
	}
	return
}


part1 :: proc(grid: [$N][N]bool, $steps: int) -> (ans: int) {
	grid0 := grid
	grid1 := grid

	rd := &grid0
	wr := &grid1

	for _ in 0 ..< steps {
		step(rd, wr)
		rd, wr = wr, rd
	}

	for row in rd {
		for lig in row {
			if lig do ans += 1
		}
	}
	return
}

part2 :: proc(grid: [$N][N]bool, $steps: int) -> (ans: int) {
	grid0 := grid
	grid1 := grid

	rd := &grid0
	wr := &grid1

	rd[0][0] = true
	rd[0][N - 1] = true
	rd[N - 1][0] = true
	rd[N - 1][N - 1] = true

	for _ in 0 ..< steps {
		step(rd, wr)
		wr[0][0] = true
		wr[0][N - 1] = true
		wr[N - 1][0] = true
		wr[N - 1][N - 1] = true
		rd, wr = wr, rd
	}

	for row in rd {
		for lig in row {
			if lig do ans += 1
		}
	}
	return
}

step :: proc(rd: ^[$N][N]bool, wr: ^[N][N]bool) {
	for i in 0 ..< N {
		for j in 0 ..< N {
			count := count_neighbors(rd, i, j)
			switch rd[i][j] {
			case true:
				switch count {
				case 2, 3:
					wr[i][j] = true
				case:
					wr[i][j] = false
				}
			case false:
				switch count {
				case 3:
					wr[i][j] = true
				case:
					wr[i][j] = false
				}
			}
		}
	}
}

count_neighbors :: proc(grid: ^[$N][N]bool, i, j: int) -> (count: int) {
	for i_off in -1 ..= 1 {
		if i + i_off < 0 || i + i_off >= N do continue
		for j_off in -1 ..= 1 {
			if j + j_off < 0 || j + j_off >= N do continue
			if i_off == 0 && j_off == 0 do continue
			if grid[i + i_off][j + j_off] do count += 1
		}
	}
	return
}

