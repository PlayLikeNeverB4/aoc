require 'set'
$times = nil
$distances = nil

def read_input
  f = File.open('input.txt', 'r')
  $times = f.readline.split(':').last.split.map{|s| Integer(s, exception: false)}.compact
  $distances = f.readline.split(':').last.split.map{|s| Integer(s, exception: false)}.compact
end

def solve
  $times.each_with_index.map do |time, idx|
    distance_record = $distances[idx]
    (time + 1).times.select do |hold|
      time_left = time - hold
      travel = time_left * hold
      travel > distance_record
    end.size
  end.inject(:*)
end

read_input

solution = solve

puts solution
