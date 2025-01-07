package main

import "core:fmt"
import "core:strings"

main :: proc() {
	e_pass := strings.split_lines(#load("e_pass.txt", string))
	e_next := strings.split_lines(#load("e_next.txt", string))
	input := strings.split_lines(#load("input.txt", string))[0]
	defer free_all()

	fmt.println(">> example:")
	fmt.println("part 1: ")
	validate_pass(e_pass)
	validate_next(e_next)

	fmt.println(">> input:")
	part1 := calc_next(input)
	fmt.println("part 1:", part1)

	aux := transmute([]u8)part1
	increment_str(&aux)
	fmt.println("part 2:", calc_next(part1))
}

validate_pass :: proc(candidates: []string) {
	for pass in candidates {
		if len(pass) == 0 do continue
		switch is_valid(pass) {
		case true:
			fmt.println(pass, "-> true")
		case false:
			fmt.println(pass, "-> false")
		}
	}
}

validate_next :: proc(candidates: []string) {
	for pass in candidates {
		if len(pass) == 0 do continue
		fmt.println(pass, "->", calc_next(pass))
	}
}

calc_next :: proc(input: string) -> string {
	pass := transmute([]u8)strings.clone(input)
	for !is_valid(string(pass)) do increment_str(&pass)
	return string(pass)
}

increment_str :: proc(pass: ^[]u8) -> (new_char: u8, carry: bool) {
	for idx := len(pass) - 1; idx >= 0; idx -= 1 {
		carry: bool
		new_char := pass[idx] + 1
		if new_char > 'z' {
			new_char = 'a'
			carry = true
		}
		pass[idx] = new_char
		if !carry do break
	}
	return
}

is_valid :: proc(pass: string) -> bool {
	has_increasing: bool
	has_prohibited: bool
	has_repeating: bool

	last_pair_idx := min(int)

	switch pass[0] {
	case 'i', 'o', 'l':
		has_prohibited = true
	}

	for i in 2 ..< len(pass) {
		win := pass[i - 2:i + 1]

		rep := -1
		if win[1] == win[2] do rep = i - 1
		if win[0] == win[1] do rep = i - 2
		if rep != -1 && last_pair_idx + 1 < rep {
			if last_pair_idx >= 0 do has_repeating = true
			last_pair_idx = rep
		}

		switch win[2] {
		case 'i', 'o', 'l':
			has_prohibited = true
		}

		if win[0] == win[1] - 1 && win[1] == win[2] - 1 do has_increasing = true
	}
	return has_increasing && !has_prohibited && has_repeating
}

