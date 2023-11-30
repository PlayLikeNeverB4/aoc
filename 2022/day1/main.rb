$calories = [[]]

def read_input
  f = File.open('input.txt', 'r')
  while !f.eof? do
    line = f.readline.strip
    if line.empty?
      $calories << []
    else
      $calories.last << line.to_i
    end
  end
end

def write_output(sol)
  f = File.open('output.txt', 'w')
  f.puts(sol)
  f.close
end

def solve
  $calories.map{|group| group.sum}.max
end

read_input

solution = solve

write_output(solution)
