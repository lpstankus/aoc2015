package main

import "core:fmt"
import "core:strconv"
import "core:strings"

Edge :: struct {
	from, to: int,
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

parse_input :: proc(raw: []u8) -> (graph: [][]int) {
	node_map := make(map[string]int)
	edge_map := make(map[Edge]int)

	str := string(raw)
	for row in strings.split_lines_iterator(&str) {
		splits := strings.split(row, " ")

		idx_a, idx_b: int
		ok: bool

		idx_a, ok = node_map[splits[0]]
		if !ok {
			node_map[splits[0]] = len(node_map)
			idx_a = node_map[splits[0]] or_else panic("UWU")
		}

		idx_b, ok = node_map[splits[2]]
		if !ok {
			node_map[splits[2]] = len(node_map)
			idx_b = node_map[splits[2]] or_else panic("UWU")
		}

		edge := Edge{idx_a, idx_b}
		edge_map[edge] = strconv.parse_int(splits[4]) or_else panic("A")
	}

	graph = make([][]int, len(node_map))
	for &row, i in graph {
		row = make([]int, len(node_map))
		for &edge, j in row {
			switch {
			case i == j:
			case {i, j} in edge_map:
				edge = edge_map[{i, j}]
			case {j, i} in edge_map:
				edge = edge_map[{j, i}]
			case:
				panic("UE")
			}
		}
	}

	return
}

part1 :: proc(input: [][]int) -> (ans: int) {
	ans = max(int)
	for i in 0 ..< len(input) {
		visited := make(map[int]bool)
		ans = min(ans, travelling_salesman(input, i, 0, &visited))
		clear(&visited)
	}
	return
}

part2 :: proc(input: [][]int) -> (ans: int) {
	for i in 0 ..< len(input) {
		visited := make(map[int]bool)
		ans = max(ans, travelling_showoff(input, i, 0, &visited))
		clear(&visited)
	}
	return
}

travelling_salesman :: proc(
	graph: [][]int,
	cur: int,
	cost: int,
	visited: ^map[int]bool,
) -> int {
	visited[cur] = true
	defer visited[cur] = false

	ans := max(int)
	for nex in 0 ..< len(graph) {
		if cur == nex do continue
		if visited[nex] do continue
		nex_cost := cost + graph[cur][nex]
		ans = min(ans, travelling_salesman(graph, nex, nex_cost, visited))
	}
	return ans if ans < max(int) else cost
}

travelling_showoff :: proc(
	graph: [][]int,
	cur: int,
	cost: int,
	visited: ^map[int]bool,
) -> int {
	visited[cur] = true
	defer visited[cur] = false

	ans := 0
	for nex in 0 ..< len(graph) {
		if cur == nex do continue
		if visited[nex] do continue
		nex_cost := cost + graph[cur][nex]
		ans = max(ans, travelling_showoff(graph, nex, nex_cost, visited))
	}
	return ans if ans != 0 else cost
}

