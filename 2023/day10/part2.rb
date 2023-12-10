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

def move_to_direction(cell, dir)
  [cell[0] + dir[0], cell[1] + dir[1]]
end

def neighbours(cell)
  DIRECTIONS.map{|dir| move_to_direction(cell, dir)}
end

def pipe_neighbours(cell)
  PIPE_DIRECTIONS[$grid[cell[0]][cell[1]]].map{|dir| move_to_direction(cell, dir)}
end

def find_pipe_path(cell, visited)
  last_cell = nil
  path = []
  while last_cell.nil? do
    visited[cell] = true
    path << cell
    next_cell = pipe_neighbours(cell).find do |next_cell|
      next unless visited[next_cell].nil?
      next if PIPE_DIRECTIONS[$grid[next_cell[0]][next_cell[1]]].nil?
      true
    end
    last_cell = cell if next_cell.nil?
    cell = next_cell
  end
  [last_cell, path]
end

def main_loop
  start = (0..$grid.size-1).to_a.product((0..$grid[0].size-1).to_a).find{|row, col| $grid[row][col] == 'S'}
  visited = { start => true }
  initial_neighbours = neighbours(start)
  max_path = 0
  initial_neighbours.each do |cell|
    next unless visited[cell].nil?
    next if PIPE_DIRECTIONS[$grid[cell[0]][cell[1]]].nil?
    next unless pipe_neighbours(cell).include?(start)
    last_cell, path = find_pipe_path(cell, visited)
    next unless pipe_neighbours(last_cell).include?(start)
    next unless initial_neighbours.include?(last_cell)
    max_path = path if path.size > max_path
  end
  max_path << start
  max_path
end

def solve
  path = main_loop
  start = path[-1]
  start_neighbours = [path[0], path[-2]].sort
  PIPE_DIRECTIONS.keys.find do |pipe|
    $grid[start[0]][start[1]] = pipe
    pipe_neighbours(start).sort == start_neighbours
  end
  cells_on_path = path.map.with_index.to_h
  inside_count = 0
  (0..$grid.size-1).each do |row|
    col = 0
    passed_pipes = 0
    while col < $grid[row].size
      if !cells_on_path[[row, col]].nil?
        raise "bad - at #{row},#{col}" if $grid[row][col] == '-'
        start_col = col
        while col + 1 < $grid[row].size &&
              !cells_on_path[[row, col + 1]].nil? &&
              [1, path.size-1].include?((cells_on_path[[row, col]] - cells_on_path[[row, col + 1]] + path.size) % path.size)
          col += 1
        end
        end_col = col
        # start = end => 1, good
        # LJ => 3, bad
        # L7 => 4, good
        total_directions = (PIPE_DIRECTIONS[$grid[row][start_col]] + PIPE_DIRECTIONS[$grid[row][end_col]]).uniq.size
        good_segment = total_directions % 2 == 0
        passed_pipes += 1 if good_segment
      else
        if passed_pipes.odd?
          inside_count += 1
        end
      end
      col += 1
    end
  end

  inside_count
end

read_input

solution = solve

puts solution
