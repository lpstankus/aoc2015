package main

import "core:fmt"

Base :: struct {
	hp, at, df: int,
}

Weapon :: struct {
	cost, at: int,
}

Armor :: struct {
	cost, df: int,
}

Ring :: struct {
	cost, at, df: int,
}

@(rodata)
weapon := []Weapon{{8, 4}, {10, 5}, {25, 6}, {40, 7}, {74, 8}}

@(rodata)
armor := []Armor{{13, 1}, {31, 2}, {53, 3}, {75, 4}, {102, 5}}

@(rodata)
rings := []Ring {
	{25, 1, 0},
	{50, 2, 0},
	{100, 3, 0},
	{20, 0, 1},
	{40, 0, 2},
	{80, 0, 3},
}

main :: proc() {
	defer free_all()

	boss, player := Base{100, 8, 2}, Base{100, 0, 0}

	fmt.println(">> input:")
	fmt.println("part 1:", part1(boss, player))
	fmt.println("part 2:", part2(boss, player))
}

part1 :: proc(boss, player: Base) -> int {
	ans := max(int)

	for w_id in 0 ..< len(weapon) {
		w := weapon[w_id]

		for a_id in -1 ..< len(armor) {
			a := armor[a_id] if a_id != -1 else Armor{}

			for r0_id in -1 ..< len(rings) {
				r0 := rings[r0_id] if r0_id != -1 else Ring{}

				for r1_id in -1 ..< (r0_id if r0_id != -1 else 1) {
					r1 := rings[r1_id] if r1_id != -1 else Ring{}

					p := player
					p.at = w.at + r0.at + r1.at
					p.df = a.df + r0.df + r1.df

					cost := w.cost + a.cost + r0.cost + r1.cost
					if winnable(boss, p) do ans = min(ans, cost)
				}
			}
		}
	}
	return ans
}

part2 :: proc(boss, player: Base) -> (ans: int) {
	for w_id in 0 ..< len(weapon) {
		w := weapon[w_id]

		for a_id in -1 ..< len(armor) {
			a := armor[a_id] if a_id != -1 else Armor{}

			for r0_id in -1 ..< len(rings) {
				r0 := rings[r0_id] if r0_id != -1 else Ring{}

				for r1_id in -1 ..< (r0_id if r0_id != -1 else 1) {
					r1 := rings[r1_id] if r1_id != -1 else Ring{}

					p := player
					p.at = w.at + r0.at + r1.at
					p.df = a.df + r0.df + r1.df

					cost := w.cost + a.cost + r0.cost + r1.cost
					if !winnable(boss, p) do ans = max(ans, cost)
				}
			}
		}
	}
	return
}

winnable :: proc(boss, player: Base) -> bool {
	b, p := boss, player

	for p.hp > 0 {
		dmg := max(1, p.at - b.df)
		b.hp -= dmg

		if b.hp <= 0 do return true

		dmg = max(1, b.at - p.df)
		p.hp -= dmg
	}
	return false
}

