$strings = [[]]

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
  digits = s.chars.map{|c| Integer(c, exception: false)}.compact
  digits.first * 10 + digits.last
end

def solve
  $strings.map{|s| extract_number(s)}.sum
end

read_input

solution = solve

write_output(solution)
