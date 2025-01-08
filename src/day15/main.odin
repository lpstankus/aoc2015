package main

import "core:fmt"
import "core:strconv"
import "core:strings"

Ingredient :: struct {
	capacity, durability, flavor, texture, calories: int,
}

main :: proc() {
	example := parse_input(#load("example.txt"))
	input := parse_input(#load("input.txt"))
	defer free_all()

	fmt.println(">> example:")
	fmt.println("part 1:", part1(example))
	fmt.println("part 2:", part2(example))

	fmt.println(">> input:")
	fmt.println("part 1:", part1(input))
	fmt.println("part 2:", part2(input))
}

parse_input :: proc(raw: []u8) -> (ret: [dynamic]Ingredient) {
	ret = make([dynamic]Ingredient)
	str := string(raw)
	for row in strings.split_lines_iterator(&str) {
		splits := strings.split_multi(row, {" ", ","})
		cap := strconv.parse_int(splits[2]) or_else panic("UWU")
		dur := strconv.parse_int(splits[5]) or_else panic("UWU")
		fla := strconv.parse_int(splits[8]) or_else panic("UWU")
		tex := strconv.parse_int(splits[11]) or_else panic("UWU")
		cal := strconv.parse_int(splits[14]) or_else panic("UWU")
		append(&ret, Ingredient{cap, dur, fla, tex, cal})
	}
	return
}

part1 :: proc(input: [dynamic]Ingredient) -> int {
	score :: proc(ingredients: []Ingredient, spoons: []int) -> int {
		cap, dur, fla, tex: int
		for i, idx in ingredients {
			cap += spoons[idx] * i.capacity
			dur += spoons[idx] * i.durability
			fla += spoons[idx] * i.flavor
			tex += spoons[idx] * i.texture
		}
		if cap < 0 || dur < 0 || fla < 0 || tex < 0 do return 0
		return cap * dur * fla * tex
	}

	spoons := make([]int, len(input))
	return traverse(input[:], score, spoons, 0, 0)
}

part2 :: proc(input: [dynamic]Ingredient) -> int {
	score :: proc(ingredients: []Ingredient, spoons: []int) -> int {
		cap, dur, fla, tex, cal: int
		for i, idx in ingredients {
			cap += spoons[idx] * i.capacity
			dur += spoons[idx] * i.durability
			fla += spoons[idx] * i.flavor
			tex += spoons[idx] * i.texture
			cal += spoons[idx] * i.calories
		}
		if cap < 0 || dur < 0 || fla < 0 || tex < 0 do return 0
		if cal != 500 do return 0
		return cap * dur * fla * tex
	}

	spoons := make([]int, len(input))
	return traverse(input[:], score, spoons, 0, 0)
}

traverse :: proc(
	ingredients: []Ingredient,
	score_proc: proc(_: []Ingredient, _: []int) -> int,
	spoons: []int,
	cur, sum: int,
) -> int {
	if cur == len(spoons) - 1 {
		spoons[cur] = 100
		for i in 0 ..< cur do spoons[cur] -= spoons[i]
		if spoons[cur] < 0 do return -1
		return score_proc(ingredients, spoons)
	}

	ans := -1
	for val in 0 ..= 100 - sum {
		spoons[cur] = val
		nsum := sum + val
		ans = max(ans, traverse(ingredients, score_proc, spoons, cur + 1, nsum))
	}
	return ans
}

