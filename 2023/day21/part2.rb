$grid = nil
RIGHT = [0, 1]
LEFT = [0, -1]
UP = [-1, 0]
DOWN = [1, 0]
DIRECTIONS = [RIGHT, UP, LEFT, DOWN]
STEP_COUNT = 26501365

def read_input
  f = File.open('input.txt', 'r')
  $grid = f.readlines.map(&:strip).map(&:chars)
end

def cell_in_bounds?(cell)
  cell[0].between?(0, $grid.size - 1) && cell[1].between?(0, $grid[0].size - 1)
end

def move_to_direction(cell, dir)
  [(cell[0] + dir[0]), (cell[1] + dir[1])]
end

def neighbours(cell)
  DIRECTIONS.map{|dir| move_to_direction(cell, dir) }
end

def normalize_cell(next_cell)
  cell = next_cell.dup
  cell[0] %= $grid.size
  cell[0] += $grid.size if cell[0] < 0
  cell[1] %= $grid[0].size
  cell[1] += $grid[0].size if cell[1] < 0
  cell
end

def manhattan(cell1, cell2)
  (cell1[0] - cell2[0]).abs + (cell1[1] - cell2[1]).abs
end

def reach_from_after_steps(start_cell, steps_count)
  can_reach = { start_cell => true }
  steps_count.times do
    new_can_reach = {}
    can_reach.each_key do |cell|
      neighbours(cell).each do |next_cell|
        ncell = normalize_cell(next_cell)
        next if $grid[ncell[0]][ncell[1]] == '#'
        new_can_reach[next_cell] = true
      end
    end
    can_reach = new_can_reach
  end

  puts "Done"
  can_reach.size
end

# Day 9
def predict_next(seq)
  return 0 if seq.all?(&:zero?)
  diffs = (0..seq.size-2).map{|idx| seq[idx + 1] - seq[idx]}
  seq.last + predict_next(diffs)
end
def predict_next_faster(sequences)
  sum = 0
  sequences.reverse_each do |s|
    sum += s.last unless s.empty?
    s << sum
  end
  sequences.first.last
end

def solve
  # Note: assuming the input's specific shape, square grid, odd length
  # 26501365 % 131 = 65
  # 26501365 / 131 = 202300
  cycle = $grid.size
  raise 'not square' if $grid.size != $grid[0].size
  raise 'not odd' if cycle.even?

  answer = 0
  squares = STEP_COUNT / cycle

  raise 'squares count not even' if squares.odd?
  # squares is even
  # squares-1 is odd

  # Used hints from reddit, use weird extrapolation algorithm from day 9
  # answer_progression = (0..2).map{|sq| reach_from_after_steps(start_cell, sq * cycle + cycle / 2) }
  answer_progression = [3867, 34253, 94909]
  sequences = [
    answer_progression,
    [answer_progression[1] - answer_progression[0], answer_progression[2] - answer_progression[1]],
    [(answer_progression[2] - answer_progression[1]) - (answer_progression[1] - answer_progression[0])],
    [],
  ]
  (squares - answer_progression.size + 1).times do |t|
    answer_progression << predict_next_faster(sequences)
  end

  answer = answer_progression.last

  # cell_distances.each do |cell, min_dist|
  #   # puts "#{cell} - #{min_dist} #{manhattan(cell, start_cell)}" if min_dist != manhattan(cell, start_cell)
  #   puts "!!!#{cell} - #{min_dist} #{manhattan(cell, start_cell)}" if min_dist > manhattan(cell, start_cell) + 6
  # end

  # cnt_odd = 0
  # cnt_even = 0
  # (0..$grid.size-1).to_a.product((0..$grid[0].size-1).to_a).each do |r, c|
  #   next if $grid[r][c] == '#'
  #   if (r + c).even? == start_cell.sum.even?
  #     cnt_even += 1
  #   else
  #     cnt_odd += 1
  #   end
  # end
  # # puts cnt_even, cnt_odd
  # # puts cell_distances.values.map(&:even?).tally

  # Previous wrong answers
  min = 61960582738097 + 1
  max = 619605827380971 - 1
  raise "answer #{answer} out of bounds: [#{min}, #{max}]" unless answer.between?(min, max)

  answer
end

read_input

solution = solve

puts solution
