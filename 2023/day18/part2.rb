$commands = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, UP, LEFT, DOWN]
DIRECTION_STRINGS = {
  'R' => RIGHT,
  'L' => LEFT,
  'D' => DOWN,
  'U' => UP,
}
DIRECTION_NUMBERS = 'RDLU'

def extract_move(hex)
  [DIRECTION_NUMBERS[hex[-1].to_i], hex[..-2].to_i(16)]
end

def read_input
  f = File.open('input.txt', 'r')
  $commands = f.readlines.map do |line|
    tokens = line.split
    extract_move(tokens[2][2..-2]) + ['_']
  end
end

def cell_in_bounds?(cell, bounds)
  cell[0].between?(bounds[0][0], bounds[0][1]) && cell[1].between?(bounds[1][0], bounds[1][1])
end

def move_to_direction(cell, dir, times)
  [cell[0] + dir[0] * times, cell[1] + dir[1] * times]
end

def neighbours(cell, bounds)
  DIRECTIONS
    .map{|dir| move_to_direction(cell, dir, 1) }
    .filter{|cell| cell_in_bounds?(cell, bounds) }
end

def run_fill(bounds, walls, row_weight, col_weight)
  visited_weight = 0
  visited = {}
  queue = []
  start_cell = [bounds[0][0], bounds[1][0]]
  visited[start_cell] = true
  queue << start_cell
  visited_weight += row_weight[0] * col_weight[0]
  while !queue.empty?
    cell = queue.shift
    neighbours(cell, bounds).each do |next_cell|
      next if visited[next_cell] || walls[next_cell]
      visited[next_cell] = true
      queue << next_cell
      visited_weight += row_weight[next_cell[0]] * col_weight[next_cell[1]]
    end
  end
  visited_weight
end

def populate_weights(items, item_weight)
  walls = item_weight.each_index.reject{|index| item_weight[index].nil?}
  items.each_with_index do |item, index|
    next unless item_weight[index].nil?
    prev_item = if index > 0 && walls.include?(index - 1) then items[index - 1] else item - 1 end
    next_item = items[index + 1] || item + 1
    item_weight[index] = (next_item - prev_item - 1)
  end
end

def solve
  puts $commands.to_s

  # Compress coords
  rows = [-1, 0, 1]
  cols = [-1, 0, 1]
  cell = [0, 0]
  $commands.each do |dstr, moves, _|
    dir = DIRECTION_STRINGS[dstr]
    cell = move_to_direction(cell, dir, moves)
    rows += (cell[0]-1..cell[0]+1).to_a
    cols += (cell[1]-1..cell[1]+1).to_a
  end
  rows = rows.sort.uniq
  cols = cols.sort.uniq
  # puts "Rows: #{rows}"
  # puts "Cols: #{cols}"

  row_weight = Array.new(rows.size)
  col_weight = Array.new(cols.size)
  cell = [0, 0]
  $commands.each do |dstr, moves, _|
    dir = DIRECTION_STRINGS[dstr]
    row_index = rows.index(cell[0])
    col_index = cols.index(cell[1])
    row_weight[row_index] = 1
    col_weight[col_index] = 1
    cell = move_to_direction(cell, dir, moves)
  end
  populate_weights(rows, row_weight)
  populate_weights(cols, col_weight)

  # puts "Rows: #{rows}"
  # puts "Cols: #{cols}"
  # puts "Row weights: #{row_weight}"
  # puts "Col weights: #{col_weight}"

  visited = {}
  cell = [0, 0]
  $commands.each do |dstr, moves, _|
    dir = DIRECTION_STRINGS[dstr]
    next_cell = move_to_direction(cell, dir, moves)

    from_row_index = rows.index(cell[0])
    to_row_index = rows.index(next_cell[0])
    from_row_index, to_row_index = to_row_index, from_row_index if from_row_index > to_row_index

    from_col_index = cols.index(cell[1])
    to_col_index = cols.index(next_cell[1])
    from_col_index, to_col_index = to_col_index, from_col_index if from_col_index > to_col_index

    # puts '----'
    (from_row_index..to_row_index).to_a.product((from_col_index..to_col_index).to_a).each do |c|
      # puts c.to_s
      visited[c] = true
    end
    cell = next_cell
  end
  bounds = visited.keys.transpose.map(&:minmax)

  # Note: this assumes that no edges are side by side, concluded by inspecting input file
  bounds[0][0] -= 1
  bounds[1][0] -= 1
  bounds[0][1] += 1
  bounds[1][1] += 1
  outside_count = run_fill(bounds, visited, row_weight, col_weight)
  total_count = row_weight.sum * col_weight.sum
  inside_count = total_count - outside_count
  # puts "outside: #{outside_count}"
  # puts "total: #{total_count}"
  # puts "inside: #{inside_count}"

  # puts bounds.to_s
  # (bounds.first[0]..bounds.first[1]).each do |r|
  #   puts (bounds.last[0]..bounds.last[1]).map{|c| if visited[[r, c]] then '#' else '.' end }.join
  # end

  inside_count
end

read_input

solution = solve

puts solution
