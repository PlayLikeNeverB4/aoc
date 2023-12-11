$grid = nil
FACTOR = 1000000

def read_input
  f = File.open('input.txt', 'r')
  $grid = f.readlines.map(&:strip).map(&:chars)
end

def solve
  empty_rows = (0..$grid.size-1).select{|row| $grid[row].all?{|cell| cell == '.'}}
  empty_cols = (0..$grid[0].size-1).select{|col| (0..$grid.size-1).all?{|row| $grid[row][col] == '.'}}
  galaxies = (0..$grid.size-1).to_a.product((0..$grid[0].size-1).to_a).select{|row, col| $grid[row][col] == '#'}
  galaxies.combination(2).map do |g1, g2|
    (g1[0] - g2[0]).abs + (g1[1] - g2[1]).abs +
      empty_rows.select{|r| r.between?(g1[0], g2[0]) || r.between?(g2[0], g1[0])}.size * (FACTOR - 1) +
      empty_cols.select{|c| c.between?(g1[1], g2[1]) || c.between?(g2[1], g1[1])}.size * (FACTOR - 1)
  end.sum
end

read_input

solution = solve

puts solution
