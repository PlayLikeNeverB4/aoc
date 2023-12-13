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

def find_horizontal_line(grid)
  (0..grid.size-2).find do |line|
    size = [line + 1, grid.size - line - 1].min
    (0..size-1).all?{|dr| grid[line - dr] == grid[line + 1 + dr]}
  end
end

def solve_grid(grid)
  row = find_horizontal_line(grid)
  return 100 * (row + 1) unless row.nil?

  grid = grid.transpose
  row = find_horizontal_line(grid)
  raise 'not found' if row.nil?
  row + 1
end

def solve
  $grids.map{|grid| solve_grid(grid)}.sum
end

read_input

solution = solve

puts solution
