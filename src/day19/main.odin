package main

import pqueue "core:container/priority_queue"
import "core:fmt"
import "core:strings"

Atom :: string
Molecule :: [dynamic]Atom

Problem :: struct {
	contractions: map[Atom]Molecule,
	expansions:   map[Atom]Molecule,
	molecule:     [dynamic]Atom,
}

PackedMolecule :: struct {
	depth: int,
	len:   int,
	buf:   [512]u8 `fmt:"s"`,
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

parse_input :: proc(raw: []u8) -> (ret: Problem) {
	using ret

	contractions = make(map[Atom]Molecule)
	expansions = make(map[Atom]Molecule)
	molecule = make([dynamic]Atom)

	str := string(raw)
	for line in strings.split_lines_iterator(&str) {
		if line == "" do break
		splits := strings.split(line, " => ")
		{
			val, ok := expansions[splits[0]]
			if !ok do val = make([dynamic]Atom)
			append(&val, splits[1])
			expansions[splits[0]] = val
		}
		{
			val, ok := contractions[splits[1]]
			if !ok do val = make([dynamic]Atom)
			append(&val, splits[0])
			contractions[splits[1]] = val
		}
	}

	last_line, _ := strings.split_lines_iterator(&str)
	for atom in next_atom(&last_line) do append(&molecule, atom)

	return
}

part1 :: proc(input: Problem) -> (ans: int) {
	seen := make(map[string]bool)
	for i := 0; i < len(input.molecule); i += 1 {
		atom := input.molecule[i]
		defer input.molecule[i] = atom

		if exp, ok := input.expansions[atom]; ok {
			for e in exp {
				input.molecule[i] = e
				new_molecule := strings.concatenate(input.molecule[:])
				if !seen[new_molecule] {
					seen[new_molecule] = true
					ans += 1
				}
			}
		}
	}
	return
}

part2 :: proc(input: Problem) -> (ans: int) {
	less :: proc(a, b: PackedMolecule) -> bool {return a.len < b.len}
	swap :: proc(a: []PackedMolecule, i, j: int) {a[i], a[j] = a[j], a[i]}

	pq: pqueue.Priority_Queue(PackedMolecule)
	pqueue.init(&pq, less, swap)

	{
		first := pack_molecule(input.molecule[:])
		pqueue.push(&pq, first)
	}

	cur := PackedMolecule{}
	for {
		el := pqueue.pop_safe(&pq) or_break
		if el.len == 1 && el.buf[0] == 'e' do return el.depth

		cur.depth = el.depth + 1

		for key, conts in input.contractions {
			cur.len = 0
			it := string(el.buf[:el.len])
			for {
				if strings.starts_with(it, key) {
					cur_len := cur.len

					for cont in conts {
						if cont == "e" &&
						   (cur.len != 0 || len(key) != len(it)) {
							continue
						}

						defer cur.len = cur_len

						copy(cur.buf[cur.len:], cont[:])
						cur.len += len(cont)

						off := len(key)
						copy(cur.buf[cur.len:], it[off:])
						cur.len += len(it) - off

						pqueue.push(&pq, cur)
					}
				}

				atom := next_atom(&it) or_break
				copy(cur.buf[cur.len:], atom[:])
				cur.len += len(atom)
			}
		}
	}
	return
}

pack_molecule :: proc(molecule: []Atom) -> (m: PackedMolecule) {
	for atom in molecule {
		for ch in atom {
			m.buf[m.len] = u8(ch)
			m.len += 1
		}
	}
	return
}

next_atom :: proc(str: ^string) -> (ret: Atom, ok: bool) {
	defer str^ = str[len(ret):]
	switch {
	case len(str) == 0:
		return "", false
	case len(str) == 1:
		return str[:], true
	case 'a' <= str[1] && str[1] <= 'z':
		return str[:2], true
	case:
		return str[:1], true
	}
}

