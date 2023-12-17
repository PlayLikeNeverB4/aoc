$grids = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, UP, LEFT, DOWN]
MIN_CONSECUTIVE = 4
MAX_CONSECUTIVE = 10

def read_input
  f = File.open('input.txt', 'r')
  $grid = f.readlines.map(&:strip).map{|line| line.chars.map(&:to_i) }
end

def cell_in_bounds?(cell)
  cell[0].between?(0, $grid.size - 1) && cell[1].between?(0, $grid[0].size - 1)
end

def move_to_direction(cell, dir, times)
  [cell[0] + dir[0] * times, cell[1] + dir[1] * times]
end

def neighbours(cell, prev_dir, min_ok)
  DIRECTIONS
    .reject{|dir| dir[0] + prev_dir[0] == 0 && dir[1] + prev_dir[1] == 0 }
    .map do |dir|
      step_count = if min_ok && dir == prev_dir then 1 else MIN_CONSECUTIVE end
      [ move_to_direction(cell, dir, step_count), dir, step_count ]
    end
    .filter{|cell, _| cell_in_bounds?(cell) }
end

def heat_on_path(cell, next_dir, step_count)
  (1..step_count).sum do |t|
    path_cell = move_to_direction(cell, next_dir, t)
    $grid[path_cell[0]][path_cell[1]]
  end
end

def solve
  min_heat = {}
  queue = []
  min_heat[[[0, 0], RIGHT, 0, false]] = 0
  queue << [[0, 0], RIGHT, 0, false, 0]
  while !queue.empty?
    cell, dir, cons, min_ok, heat = queue.shift
    next if heat != min_heat[[cell, dir, cons, min_ok]]

    next_states = neighbours(cell, dir, min_ok)

    next_states.each do |next_cell, next_dir, step_count|
      next_cons = if dir == next_dir then cons + step_count else step_count end
      next_min_ok = dir == next_dir || step_count == MIN_CONSECUTIVE
      next_heat = heat + heat_on_path(cell, next_dir, step_count)
      next_state = [next_cell, next_dir, next_cons, next_min_ok]
      if next_cons <= MAX_CONSECUTIVE && (min_heat[next_state].nil? || next_heat < min_heat[next_state])
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
