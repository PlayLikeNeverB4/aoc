$grid = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, UP, LEFT, DOWN]
STEP_COUNT = 64

def read_input
  f = File.open('input.txt', 'r')
  $grid = f.readlines.map(&:strip).map(&:chars)
end

def cell_in_bounds?(cell)
  cell[0].between?(0, $grid.size - 1) && cell[1].between?(0, $grid[0].size - 1)
end

def move_to_direction(cell, dir)
  [(cell[0] + dir[0] + $grid.size) % $grid.size, (cell[1] + dir[1] + $grid[0].size) % $grid[0].size]
end

def neighbours(cell)
  DIRECTIONS.map{|dir| move_to_direction(cell, dir) }
end

def solve
  can_reach = {}
  (0..$grid.size-1).to_a.product((0..$grid[0].size-1).to_a).each do |r, c|
    can_reach[[r, c]] = true if $grid[r][c] == 'S'
  end
  STEP_COUNT.times do
    new_can_reach = {}
    can_reach.keys.each do |r, c|
      neighbours([r, c]).each do |nr, nc|
        next if $grid[nr][nc] == '#'
        new_can_reach[[nr, nc]] = true
      end
    end
    can_reach = new_can_reach
  end

  can_reach.size
end

read_input

solution = solve

puts solution
