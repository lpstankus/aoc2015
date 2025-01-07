package main

import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	example := parse_input(#load("example.txt"))
	input_p1 := parse_input(#load("input.txt"))
	input_p2 := parse_input(#load("input.txt"), true)
	defer free_all()

	fmt.println(">> example:")
	fmt.println("part 1:", solve(example))

	fmt.println(">> input:")
	fmt.println("part 1:", solve(input_p1))
	fmt.println("part 2:", solve(input_p2))
}

parse_input :: proc(raw: []u8, p2: bool = false) -> (graph: [][]int) {
	Edge :: struct {
		from, to: int,
	}

	node_map := make(map[string]int)
	edge_map := make(map[Edge]int)

	str := string(raw)
	for row in strings.split_lines_iterator(&str) {
		splits := strings.split(row[:len(row) - 1], " ")

		sub := splits[0]
		tar := splits[10]

		idx_a, idx_b: int
		ok: bool

		idx_a, ok = node_map[sub]
		if !ok {
			node_map[sub] = len(node_map)
			idx_a = node_map[sub] or_else panic("UWU")
		}

		idx_b, ok = node_map[tar]
		if !ok {
			node_map[tar] = len(node_map)
			idx_b = node_map[tar] or_else panic("UWU")
		}

		mul := 1 if splits[2] == "gain" else -1
		hap := mul * (strconv.parse_int(splits[3]) or_else panic("UWU"))

		edge := Edge{idx_a, idx_b}
		edge_map[edge] = hap
	}

	plus_one := 1 if p2 else 0
	graph = make([][]int, len(node_map) + plus_one)
	for &row, i in graph {
		row = make([]int, len(node_map) + plus_one)
		for &edge, j in row {
			switch {
			case i == j:
			case {i, j} in edge_map:
				edge = edge_map[{i, j}]
			}
		}
	}

	return
}

solve :: proc(graph: [][]int) -> int {
	l := len(graph)
	seatd := make([]bool, l)
	table := make([]int, l)
	return brute(graph, seatd, table, 0)
}

brute :: proc(graph: [][]int, seatd: []bool, table: []int, cur: int) -> int {
	l := len(table)

	if cur == l do return table_happines(graph, table)

	ans := min(int)
	for i in 0 ..< l {
		if seatd[i] do continue

		table[cur] = i
		seatd[i] = true
		ans = max(ans, brute(graph, seatd, table, cur + 1))
		seatd[i] = false
	}
	return ans
}

table_happines :: proc(graph: [][]int, table: []int) -> (ans: int) {
	l := len(table)

	if l <= 1 do return
	if l == 2 do return graph[table[0]][table[1]] + graph[table[1]][table[0]]

	for i in 0 ..< l {
		cur := table[i]
		a := table[(i - 1) %% l]
		b := table[(i + 1) %% l]
		ans += graph[cur][a] + graph[cur][b]
	}
	return
}

