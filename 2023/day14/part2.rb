$grids = nil

def read_input
  f = File.open('input.txt', 'r')
  $grid = f.readlines.map(&:strip).map(&:chars)
end

def calc_load(grid)
  sum = 0
  grid[0].each_index do |col|
    grid.each_index do |row|
      if grid[row][col] == 'O'
        sum += grid.size - row
      end
    end
  end
  sum
end

def tilt_north(grid)
  new_grid = Array.new(grid.size) { Array.new(grid[0].size) { '.' } }
  grid[0].each_index do |col|
    last_row = 0
    grid.each_index do |row|
      next if grid[row][col] == '.'
      if grid[row][col] == 'O'
        new_grid[last_row][col] = 'O'
        last_row += 1
      elsif grid[row][col] == '#'
        new_grid[row][col] = '#'
        last_row = row + 1
      end
    end
  end
  new_grid
end

def rotate_clockwise(grid)
  new_grid = Array.new(grid.size) { Array.new(grid[0].size) { 'X' } }
  new_grid.each_index do |row|
    new_grid[row].each_index do |col|
      new_grid[col][grid.size - 1 - row] = grid[row][col]
    end
  end
  new_grid
end

def run_cycle(grid)
  4.times do
    grid = tilt_north(grid)
    grid = rotate_clockwise(grid)
  end
  grid
end

def solve
  grid = $grid
  visited = {}
  step_count = 0
  while visited[grid].nil?
    visited[grid] = step_count
    grid = run_cycle(grid)
    step_count += 1
  end
  cycle_length = step_count - visited[grid]
  next_total_steps = 1_000_000_000 - step_count
  next_rest_steps = next_total_steps % cycle_length
  next_rest_steps.times do
    grid = run_cycle(grid)
  end
  calc_load(grid)
end

read_input

solution = solve

puts solution
