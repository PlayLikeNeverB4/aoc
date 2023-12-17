$grids = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, UP, LEFT, DOWN]

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

def neighbours(cell, prev_dir)
  DIRECTIONS
    .reject{|dir| dir[0] + prev_dir[0] == 0 && dir[1] + prev_dir[1] == 0 }
    .map{|dir| [ move_to_direction(cell, dir), dir ] }
    .filter{|cell, _| cell_in_bounds?(cell) }
end

def solve
  min_heat = {}
  queue = []
  min_heat[[[0, 0], RIGHT, 0]] = 0
  queue << [[0, 0], RIGHT, 0, 0]
  while !queue.empty?
    cell, dir, cons, heat = queue.shift
    next if heat != min_heat[[cell, dir, cons]]

    next_states = neighbours(cell, dir)

    next_states.each do |next_cell, next_dir|
      next_cons = if dir == next_dir then cons + 1 else 1 end
      next_heat = heat + $grid[next_cell[0]][next_cell[1]].to_i
      next_state = [next_cell, next_dir, next_cons]
      if next_cons <= 3 && (min_heat[next_state].nil? || next_heat < min_heat[next_state])
        min_heat[next_state] = next_heat
        queue << next_state + [next_heat]
      end
    end
  end

  min_heat.filter{|entry| entry.first == [$grid.size - 1, $grid[0].size - 1]}.map{|entry| entry.last}.min
end

read_input

solution = solve

puts solution
