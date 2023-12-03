$map = nil
EMPTY = -1.freeze
PART = -2.freeze
DIRECTIONS = [
  [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1],
].freeze

def read_input
  f = File.open('input.txt', 'r')
  $map = f.map do |line|
    line.strip.chars.map do |c|
      next EMPTY if c == '.'
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
  sum = 0
  $map.each_with_index do |row, row_index|
    col_index = 0
    while col_index < row.size
      cell = row[col_index]
      if cell == EMPTY || cell == PART
        col_index += 1
        next
      end
      c = col_index
      crt_number = cell
      is_adjacent = neighbours(row_index, c).any?{|r, c| $map[r][c] == PART}
      while c + 1 < row.size && row[c + 1] != EMPTY && row[c + 1] != PART
        c += 1
        crt_number = 10 * crt_number + row[c]
        if !is_adjacent
          is_adjacent = neighbours(row_index, c).any?{|r, c| $map[r][c] == PART}
        end
      end
      col_index = c + 1
      sum += crt_number if is_adjacent
    end
  end
  sum
end

read_input

solution = solve

puts solution
