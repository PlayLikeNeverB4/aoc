$grids = nil

def read_input
  f = File.open('input.txt', 'r')
  $grid = f.readlines.map(&:strip).map(&:chars)
end

def solve
  sum = 0
  $grid[0].each_index do |col|
    last_row = 0
    $grid.each_index do |row|
      next if $grid[row][col] == '.'
      if $grid[row][col] == 'O'
        sum += $grid.size - last_row
        last_row += 1
      elsif $grid[row][col] == '#'
        last_row = row + 1
      end
    end
  end
  sum
end

read_input

solution = solve

puts solution
