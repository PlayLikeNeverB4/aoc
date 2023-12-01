$strings = nil
DIGITS = %w[one two three four five six seven eight nine 1 2 3 4 5 6 7 8 9].freeze

def read_input
  f = File.open('input.txt', 'r')
  $strings = f.map(&:strip)
end

def write_output(sol)
  f = File.open('output.txt', 'w')
  f.puts(sol)
  f.close
end

def extract_number(s)
  DIGITS.flat_map.with_index do |d, idx|
    [
      s.index(d) ? [s.index(d), idx] : nil,
      s.rindex(d) ? [s.rindex(d), idx] : nil,
    ].compact
  end.minmax.map(&:last).map{|idx| idx < 9 ? idx + 1 : idx - 8}.join.to_i
end

def solve
  $strings.map{|s| extract_number(s)}.sum
end

read_input

solution = solve

write_output(solution)
