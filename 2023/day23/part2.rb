$grid = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, UP, LEFT, DOWN]
FORCED_DIRECTIONS = {
  '>' => [ RIGHT ],
  '<' => [ LEFT ],
  '^' => [ UP ],
  'v' => [ DOWN ],
}

def read_input
  f = File.open('input.txt', 'r')
  $grid = f.readlines.map(&:strip).map(&:chars)
end

def cell_in_bounds?(cell)
  cell[0].between?(0, $grid.size - 1) && cell[1].between?(0, $grid[0].size - 1)
end

def move_to_direction(cell, dir)
  [cell[0] + dir[0], cell[1] + dir[1]]
end

def neighbours(cell)
  DIRECTIONS
    .map{|dir| move_to_direction(cell, dir) }
    .filter{|cell| cell_in_bounds?(cell) }
end

def get_dist(cell, prev_cell, to, junctions)
  return 0 if cell == to
  neighbours(cell).each do |next_cell|
    next if next_cell == prev_cell
    next if $grid[cell[0]][cell[1]] == '#'
    next if junctions[next_cell] && next_cell != to
    dist = get_dist(next_cell, cell, to, junctions)
    return dist + 1 if !dist.nil?
  end
  nil
end

$go_answer = 0
def go(node, mask, end_node, dist, adj)
  if node == end_node
    $go_answer = [$go_answer, dist].max
    return
  end
  adj[node].each do |next_node, edge_dist|
    next if (mask & (1 << next_node)) > 0
    next_dist = dist + edge_dist
    next_mask = mask | (1 << next_node)
    go(next_node, next_mask, end_node, next_dist, adj)
  end
end

def solve
  start_cell = [ 0, $grid[0].index('.') ]
  end_cell = [ $grid.size - 1, $grid.last.index('.') ]

  # free_cells = 0
  # (0..$grid.size-1).to_a.product((0..$grid[0].size-1).to_a).each do |r, c|
  #   free_cells += 1 if $grid[r][c] != '#'
  # end
  # puts free_cells

  junctions = {}
  junctions[start_cell] = junctions.size + 1
  junctions[end_cell] = junctions.size + 1
  (0..$grid.size-1).to_a.product((0..$grid[0].size-1).to_a).each do |cell|
    next if $grid[cell[0]][cell[1]] == '#'
    junctions[cell] = junctions.size + 1 if neighbours(cell).filter{|r, c| $grid[r][c] != '#'} .size > 2
  end
  # puts junctions
  # Conclusion: 34 junctions on the big map, we can keep their visited states in bitmask

  edges = []
  junctions.each do |from, fidx|
    junctions.each do |to, tidx|
      next if from == to
      next if fidx > tidx
      d = get_dist(from, nil, to, junctions)
      edges << [fidx, tidx, d] if !d.nil?
    end
  end

  adj = {}
  edges.each do |from, to, d|
    adj[from] ||= []
    adj[from] << [to, d]
    adj[to] ||= []
    adj[to] << [from, d]
  end

  start_node = junctions[start_cell]
  end_node = junctions[end_cell]

  # DFS is pretty fast here ~ 20s
  $go_answer = 0
  go(start_node, 0, end_node, 0, adj)
  answer = $go_answer

  # BFS slower (because of the hash map?) ~ 60s
  # dist = {}
  # queue = []
  # dist[[start_node, 0]] = 0
  # queue << [start_node, 0, 0]
  # answer = 0
  # while !queue.empty?
  #   node, mask, d = queue.shift
  #   next if dist[[node, mask]] != d
  #   if node == end_node
  #     # puts answer if d > answer
  #     answer = [answer, d].max
  #     next
  #   end

  #   adj[node].each do |next_node, edge_dist|
  #     next if (mask & (1 << next_node)) > 0
  #     next_dist = d + edge_dist
  #     next_mask = mask | (1 << next_node)
  #     next_state = [next_node, next_mask]
  #     if dist[next_state].nil? || next_dist > dist[next_state]
  #       dist[next_state] = next_dist
  #       queue << (next_state + [next_dist])
  #     end
  #   end
  # end
  
  # Original BFS on the uncompressed grid :D took hours to run
  # dist = {}
  # queue = []
  # dist[[start_cell, nil, []]] = 0
  # queue << [start_cell, nil, [], 0]
  # answer = 0
  # while !queue.empty?
  #   cell, prev_cell, juncs, d = queue.shift
  #   next if dist[[cell, prev_cell, juncs]] != d
  #   if cell == end_cell
  #     answer = [answer, d].max
  #     puts answer
  #   end

  #   neighbours(cell).each do |next_cell|
  #     next if next_cell == prev_cell
  #     next if $grid[next_cell[0]][next_cell[1]] == '#'
  #     # next if junctions[next_cell] && (juncs & (1 << junctions[next_cell])) > 0
  #     next if junctions[next_cell] && juncs.include?(junctions[next_cell])
  #     next_dist = d + 1
  #     # next_juncs = juncs + if junctions[next_cell] then 1 << junctions[next_cell] else 0 end
  #     next_juncs = (juncs + [junctions[next_cell]].reject(&:nil?)).last(2)
  #     next_state = [next_cell, cell, next_juncs]
  #     if dist[next_state].nil? || next_dist > dist[next_state]
  #       dist[next_state] = next_dist
  #       queue << (next_state + [next_dist])
  #     end
  #   end
  # end

  answer
end

read_input

solution = solve

puts solution
