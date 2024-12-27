package day03

import "base:runtime"
import "core:fmt"
import "core:strings"

main :: proc() {
	example1 := #load("example1.txt")
	example2 := #load("example2.txt")
	input := #load("input.txt")
	defer free_all()

	fmt.println(">> examples:")
	fmt.println("part 1:", part1(example1))
	fmt.println("part 2:", part2(example2))

	fmt.println(">> input:")
	fmt.println("part 1:", part1(input))
	fmt.println("part 2:", part2(input))
}

part1 :: proc(input: []u8) -> int {
	ans := 0
	str := string(input)
	outer: for line in strings.split_lines_iterator(&str) {
		has_dup: bool
		vowel_count: int = is_vowel(line[0])
		for i in 1 ..< len(line) {
			vowel_count += is_vowel(line[i])
			if is_invalid(line[i - 1:i + 1]) do continue outer
			if line[i - 1] == line[i] do has_dup = true
		}
		if has_dup && vowel_count >= 3 do ans += 1
	}
	return ans
}

part2 :: proc(input: []u8) -> int {
	ans := 0
	pairs := make(map[string]int)
	str := string(input)

	for line in strings.split_lines_iterator(&str) {
		clear(&pairs)
		nice_pair: bool
		nice_pack: bool

		pairs[line[0:2]] = 1
		for i in 1 ..< len(line) {
			key := line[i - 1:i + 1]
			if idx, ok := pairs[key]; ok {
				if idx < i - 1 do nice_pair = true
			} else {
				pairs[key] = i
			}
			if i >= 2 && line[i - 2] == line[i] do nice_pack = true
		}
		if nice_pack && nice_pair do ans += 1
	}
	return ans
}

is_vowel :: proc(char: u8) -> int {
	switch (char) {
	case 'a', 'e', 'i', 'o', 'u':
		return 1
	case:
		return 0
	}
}

is_invalid :: proc(input: string) -> bool {
	switch (input) {
	case "ab", "cd", "pq", "xy":
		return true
	case:
		return false
	}
}

