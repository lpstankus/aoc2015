package main

import "core:fmt"
import "core:strconv"
import "core:strings"

Assignment :: distinct string
Negation :: distinct string

Operand :: enum {
	AND,
	OR,
	LSHIFT,
	RSHIFT,
}

Operation :: struct {
	lhs: string,
	rhs: string,
	op:  Operand,
}

Expression :: union {
	u16,
	Assignment,
	Negation,
	Operation,
}

main :: proc() {
	input1 := parse_input(#load("input.txt"))
	input2 := parse_input(#load("input.txt"))
	defer free_all()

	part1 := resolve(&input1, "a")
	input2["b"] = part1
	part2 := resolve(&input2, "a")

	fmt.println(">> input:")
	fmt.println("part 1:", part1)
	fmt.println("part 2:", part2)
}

parse_input :: proc(raw: []u8) -> (expr: map[string]Expression) {
	str := string(raw)
	for line in strings.split_lines_iterator(&str) {
		splits := strings.split(line, " ")
		switch len(splits) {
		case 3:
			expr[splits[2]] = Assignment(splits[0])
		case 4:
			expr[splits[3]] = Negation(splits[1])
		case 5:
			switch splits[1] {
			case "AND":
				expr[splits[4]] = Operation{splits[0], splits[2], .AND}
			case "OR":
				expr[splits[4]] = Operation{splits[0], splits[2], .OR}
			case "LSHIFT":
				expr[splits[4]] = Operation{splits[0], splits[2], .LSHIFT}
			case "RSHIFT":
				expr[splits[4]] = Operation{splits[0], splits[2], .RSHIFT}
			case:
				panic(line)
			}
		case:
			panic(line)
		}
	}
	return
}

resolve :: proc(expr: ^map[string]Expression, reg: string) -> (resolved: u16) {
	if expr[reg] == nil {
		return u16(strconv.parse_uint(reg) or_else panic("UWU"))
	}

	switch e in expr[reg] {
	case u16:
		resolved = e
	case Assignment:
		resolved = resolve(expr, string(e))
	case Negation:
		resolved = ~resolve(expr, string(e))
	case Operation:
		lhs := resolve(expr, e.lhs)
		rhs := resolve(expr, e.rhs)
		switch e.op {
		case .AND:
			resolved = lhs & rhs
		case .OR:
			resolved = lhs | rhs
		case .LSHIFT:
			resolved = lhs << rhs
		case .RSHIFT:
			resolved = lhs >> rhs
		}
	}
	expr[reg] = resolved
	return
}

