$grids = nil

def read_input
  f = File.open('input.txt', 'r')
  $grids = []
  while !f.eof?
    grid = []
    while !f.eof? && !(line = f.readline.strip).empty?
      grid << line.strip.chars
    end
    $grids << grid if grid.size > 0
  end
end

def find_horizontal_line(grid, exception_line)
  (0..grid.size-2).find do |line|
    next if line == exception_line
    size = [line + 1, grid.size - line - 1].min
    (0..size-1).all?{|dr| grid[line - dr] == grid[line + 1 + dr]}
  end
end

def reflection_score(grid, exception = nil)
  row = find_horizontal_line(grid, !exception.nil? && exception >= 100 ? exception / 100 - 1 : nil)
  return 100 * (row + 1) unless row.nil? || 100 * (row + 1) == exception

  grid = grid.transpose
  row = find_horizontal_line(grid, !exception.nil? && exception < 100 ? exception - 1 : nil)
  return row + 1 unless row.nil? || row + 1 == exception

  nil
end

def solve_grid(grid)
  old_score = reflection_score(grid)
  raise 'not found before' if old_score.nil?

  (0..grid.size-1).to_a.product((0..grid[0].size-1).to_a).each do |row, col|
    grid[row][col] = grid[row][col] == '.' ? '#' : '.'
    score = reflection_score(grid, old_score)
    grid[row][col] = grid[row][col] == '.' ? '#' : '.'
    return score if !score.nil?
  end

  raise 'not found after'
end

def solve
  $grids.map{|grid| solve_grid(grid)}.sum
end

read_input

solution = solve

puts solution
