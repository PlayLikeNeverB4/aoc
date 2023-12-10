$grid = nil
UP = [-1, 0]
LEFT = [0, -1]
RIGHT = [0, 1]
DOWN = [1, 0]
DIRECTIONS = [UP, LEFT, RIGHT, DOWN]
PIPE_DIRECTIONS = {
  'L' => [UP, RIGHT],
  'J' => [UP, LEFT],
  '7' => [DOWN, LEFT],
  'F' => [DOWN, RIGHT],
  '|' => [UP, DOWN],
  '-' => [LEFT, RIGHT],
}

def read_input
  f = File.open('input.txt', 'r')
  $grid = f.readlines.map(&:strip).map(&:chars)
end

def neighbours(cell)
  DIRECTIONS.map{|drow, dcol| [cell[0] + drow, cell[1] + dcol]}
end

def pipe_neighbours(cell)
  PIPE_DIRECTIONS[$grid[cell[0]][cell[1]]].map{|drow, dcol| [cell[0] + drow, cell[1] + dcol]}
end

def find_pipe_path(cell, visited)
  last_cell = nil
  path_length = 0
  while last_cell.nil? do
    visited[cell] = true
    path_length += 1
    next_cell = pipe_neighbours(cell).find do |next_cell|
      next unless visited[next_cell].nil?
      next if PIPE_DIRECTIONS[$grid[next_cell[0]][next_cell[1]]].nil?
      true
    end
    last_cell = cell if next_cell.nil?
    cell = next_cell
  end
  [last_cell, path_length]
end

def solve
  start = (0..$grid.size-1).to_a.repeated_permutation(2).find{|row, col| $grid[row][col] == 'S'}
  visited = { start => true }
  initial_neighbours = neighbours(start)
  max_dist = 0
  initial_neighbours.each do |cell|
    next unless visited[cell].nil?
    next if PIPE_DIRECTIONS[$grid[cell[0]][cell[1]]].nil?
    next unless pipe_neighbours(cell).include?(start)
    last_cell, path_length = find_pipe_path(cell, visited)
    next unless pipe_neighbours(last_cell).include?(start)
    next unless initial_neighbours.include?(last_cell)
    max_dist = [max_dist, (path_length + 1) / 2].max
  end

  max_dist
end

read_input

solution = solve

puts solution
