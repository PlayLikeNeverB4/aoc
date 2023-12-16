$grids = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, LEFT, UP, DOWN]
SPLITTER_DIRECTIONS = {
  '-' => [LEFT, RIGHT],
  '|' => [UP, DOWN],
}
MIRROR_DIRECTIONS = {
  ['/', RIGHT] => UP,
  ['/', UP] => RIGHT,
  ['/', LEFT] => DOWN,
  ['/', DOWN] => LEFT,
  ['\\', RIGHT] => DOWN,
  ['\\', DOWN] => RIGHT,
  ['\\', LEFT] => UP,
  ['\\', UP] => LEFT,
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

def neighbours(cell, d)
  cell_value = $grid[cell[0]][cell[1]]

  if cell_value == '.'
    return [[move_to_direction(cell, d), d]]
  end

  if SPLITTER_DIRECTIONS.has_key?(cell_value)
    if SPLITTER_DIRECTIONS[cell_value].include?(d)
      return [[move_to_direction(cell, d), d]]
    else
      return SPLITTER_DIRECTIONS[cell_value].map{|sp_dir| [move_to_direction(cell, sp_dir), sp_dir] }
    end
  end

  mirror_dir = MIRROR_DIRECTIONS[[cell_value, d]]
  [[move_to_direction(cell, mirror_dir), mirror_dir]]
end

def solve
  visited = {}
  visited[[[0, 0], RIGHT]] = true
  queue = [[[0, 0], RIGHT]]
  while !queue.empty?
    cell, direction = queue.shift

    next_states = neighbours(cell, direction).filter{|cell, _| cell_in_bounds?(cell)}

    next_states.each do |next_state|
      next if visited[next_state]

      visited[next_state] = true
      queue << next_state
    end
  end

  visited_cells = visited.map{|entry| entry.first.first}.uniq
  visited_cells.size
end

read_input

solution = solve

puts solution
