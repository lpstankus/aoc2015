package main

import pqueue "core:container/priority_queue"
import "core:fmt"

InstEff :: struct {
	tag: enum {
		Drain,
		Damage,
	},
	val: int,
}

LastEff :: struct {
	tag: enum {
		Shield,
		Poison,
		Recharge,
	},
	val: int,
	dur: int,
}

Spell :: struct {
	cost:   int,
	effect: union {
		InstEff,
		LastEff,
	},
}

spells := []Spell {
	{53, InstEff{.Damage, 4}},
	{73, InstEff{.Drain, 2}},
	{113, LastEff{.Shield, 7, 6}},
	{173, LastEff{.Poison, 3, 6}},
	{229, LastEff{.Recharge, 101, 5}},
}

Base :: struct {
	hp, atk, def, mana: int,
}

main :: proc() {
	defer free_all()

	boss, player := Base{58, 9, 0, 0}, Base{50, 0, 0, 500}

	fmt.println(">> input:")
	fmt.println("part 1:", solve(boss, player))
	fmt.println("part 2:", solve(boss, player, true))
}

solve :: proc(base_boss, base_player: Base, hard: bool = false) -> int {
	Turn :: struct {
		boss:  Base,
		play:  Base,
		effs:  []LastEff,
		spent: int,
	}

	swap :: proc(a: []Turn, i, j: int) {a[i], a[j] = a[j], a[i]}
	less :: proc(a, b: Turn) -> bool {return a.spent < b.spent}

	pq: pqueue.Priority_Queue(Turn)
	pqueue.init(&pq, less, swap)

	pqueue.push(&pq, Turn{boss = base_boss, play = base_player})

	for turn in pqueue.pop_safe(&pq) {
		outer: for spell in spells {
			b, p := turn.boss, turn.play
			if p.mana < spell.cost do continue

			running_effects := make([dynamic]LastEff)
			append(&running_effects, ..turn.effs)

			{ 	// Player's turn
				apply_effects(&b, &p, &running_effects)
				if hard do p.hp -= 1
				if b.hp <= 0 do return turn.spent

				defer p.def = base_player.def

				switch eff in spell.effect {
				case InstEff:
					switch eff.tag {
					case .Drain:
						b.hp -= eff.val
						p.hp += eff.val
					case .Damage:
						b.hp -= eff.val
					}
					if b.hp <= 0 do return turn.spent + spell.cost
				case LastEff:
					for running_eff in running_effects {
						if running_eff.dur > 1 && running_eff.tag == eff.tag {
							continue outer
						}
					}
					append(&running_effects, eff)
				}
				p.mana -= spell.cost
			}

			{ 	// Boss' turn
				apply_effects(&b, &p, &running_effects)
				if hard do p.hp -= 1
				if b.hp <= 0 do return turn.spent + spell.cost

				defer p.def = base_player.def

				p.hp -= max(1, b.atk - p.def)
				if p.hp <= 0 do continue
			}

			new_turn := Turn {
				boss  = b,
				play  = p,
				effs  = running_effects[:],
				spent = turn.spent + spell.cost,
			}
			pqueue.push(&pq, new_turn)
		}
	}

	return -1
}

apply_effects :: proc(b, p: ^Base, effs: ^[dynamic]LastEff) {
	for &eff in effs {
		switch eff.tag {
		case .Shield:
			p.def += eff.val
		case .Poison:
			b.hp -= eff.val
		case .Recharge:
			p.mana += eff.val
		}
		eff.dur -= 1
	}

	for i := 0; i < len(effs); i += 1 {
		if effs[i].dur == 0 {
			unordered_remove(effs, i)
			i -= 1
		}
	}
}

