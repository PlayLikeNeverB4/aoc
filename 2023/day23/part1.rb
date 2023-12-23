$grid = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, UP, LEFT, DOWN]
FORCED_DIRECTIONS = {
  '>' => [ RIGHT ],
  '<' => [ LEFT ],
  '^' => [ UP ],
  'v' => [ DOWN ],
}

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
  dirs = FORCED_DIRECTIONS[$grid[cell[0]][cell[1]]]
  dirs = DIRECTIONS if dirs.nil?
  dirs.map{|dir| move_to_direction(cell, dir) }
end

def cycle?(cell, prev_cell, visited)
  visited[cell] = true
  neighbours(cell).each do |next_cell|
    next if $grid[next_cell[0]][next_cell[1]] == '#'
    next if next_cell == prev_cell
    puts next_cell.to_s if visited[next_cell]
    return true if visited[next_cell]
    if cycle?(next_cell, cell, visited)
      puts next_cell.to_s
      return true 
    end
  end
  visited[cell] = false
  false
end

def solve
  start_cell = [ 0, $grid[0].index('.') ]
  end_cell = [ $grid.size - 1, $grid.last.index('.') ]

  # empty_cells = 0
  # (0..$grid.size-1).to_a.product((0..$grid[0].size-1).to_a).each do |r, c|
  #   empty_cells += 1 if $grid[r][c] != '#'
  # end

  # visited = {}
  # if cycle?(start_cell, nil, visited)
  #   puts "It's so over"
  # else
  #   puts 'We are so back'
  # end
  # Conclusion: no cycles, so simple bfs works
  
  dist = {}
  queue = []
  dist[start_cell] = 0
  queue << [start_cell, nil, 0]
  while !queue.empty?
    cell, prev_cell, d = queue.shift
    next if dist[cell] != d

    neighbours(cell).each do |next_cell|
      next if next_cell == prev_cell
      next if $grid[next_cell[0]][next_cell[1]] == '#'
      next_dist = d + 1
      if dist[next_cell].nil? || next_dist > dist[next_cell]
        dist[next_cell] = next_dist
        queue << [next_cell, cell, next_dist]
      end
    end
  end

  dist[end_cell]
end

read_input

solution = solve

puts solution
