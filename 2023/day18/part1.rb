$commands = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, UP, LEFT, DOWN]
DIRECTION_STRINGS = {
  'R' => RIGHT,
  'L' => LEFT,
  'D' => DOWN,
  'U' => UP,
}

def read_input
  f = File.open('input.txt', 'r')
  $commands = f.readlines.map do |line|
    tokens = line.split
    [tokens[0], tokens[1].to_i, tokens[2][1..-2]]
  end
end

def cell_in_bounds?(cell, bounds)
  cell[0].between?(bounds[0][0], bounds[0][1]) && cell[1].between?(bounds[1][0], bounds[1][1])
end

def move_to_direction(cell, dir)
  [cell[0] + dir[0], cell[1] + dir[1]]
end

def neighbours(cell, bounds)
  DIRECTIONS
    .map{|dir| move_to_direction(cell, dir) }
    .filter{|cell| cell_in_bounds?(cell, bounds) }
end

def run_fill(bounds, walls)
  visited = {}
  queue = []
  start_cell = [bounds[0][0], bounds[1][0]]
  visited[start_cell] = true
  queue << start_cell
  while !queue.empty?
    cell = queue.shift
    neighbours(cell, bounds).each do |next_cell|
      next if visited[next_cell] || walls[next_cell]
      visited[next_cell] = true
      queue << next_cell
    end
  end
  visited.size
end

def solve
  visited = {}
  cell = [0, 0]
  visited[cell] = 0
  $commands.each_with_index do |command, index|
    dstr, moves, _ = command
    dir = DIRECTION_STRINGS[dstr]
    moves.times do
      cell = move_to_direction(cell, dir)
      visited[cell] = index
    end
  end
  bounds = visited.keys.transpose.map(&:minmax)

  # Note: this assumes that no edges are side by side, concluded by inspecting input file
  bounds[0][0] -= 1
  bounds[1][0] -= 1
  bounds[0][1] += 1
  bounds[1][1] += 1
  outside_count = run_fill(bounds, visited)
  total_count = (bounds[0][1] - bounds[0][0] + 1) * (bounds[1][1] - bounds[1][0] + 1)
  inside_count = total_count - outside_count
  inside_count
end

read_input

solution = solve

puts solution
