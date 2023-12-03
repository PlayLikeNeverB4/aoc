require 'set'
$map = nil
EMPTY = -1.freeze
GEAR = -2.freeze
PART = -3.freeze
DIRECTIONS = [
  [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1],
].freeze

def read_input
  f = File.open('input.txt', 'r')
  $map = f.map do |line|
    line.strip.chars.map do |c|
      next EMPTY if c == '.'
      next GEAR if c == '*'
      value = Integer(c, exception: false)
      next PART if value.nil?
      value
    end
  end
end

def neighbours(r, c)
  DIRECTIONS.filter_map do |dr, dc|
    nr = r + dr
    nc = c + dc
    if nr < 0 || nr >= $map.size || nc < 0 || nc >= $map[0].size
      next nil
    end
    [nr, nc]
  end
end

def solve
  number_index = Array.new($map.size) { Array.new($map[0].size) { -1 } }
  numbers = []
  $map.each_with_index do |row, row_index|
    col_index = 0
    while col_index < row.size
      cell = row[col_index]
      if cell == EMPTY || cell == PART || cell == GEAR
        col_index += 1
        next
      end
      c = col_index
      crt_number = cell
      while c + 1 < row.size && row[c + 1] != EMPTY && row[c + 1] != PART && row[c + 1] != GEAR
        c += 1
        crt_number = 10 * crt_number + row[c]
      end
      (col_index..c).each{|cc| number_index[row_index][cc] = numbers.size }
      numbers << crt_number
      col_index = c + 1
    end
  end

  sum = 0
  $map.each_with_index do |row, row_index|
    row.each_with_index do |cell, col_index|
      next if cell != GEAR
      adjacent_numbers = Set.new
      neighbours(row_index, col_index).each do |r, c|
        adjacent_numbers.add(number_index[r][c]) if number_index[r][c] != -1
      end
      next if adjacent_numbers.size != 2
      ratio = adjacent_numbers.map{|idx| numbers[idx] }.inject(:*)
      sum += ratio
    end
  end
  sum
end

read_input

solution = solve

puts solution
