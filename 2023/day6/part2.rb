require 'set'
$times = nil
$distances = nil

def read_input
  f = File.open('input.txt', 'r')
  $times = f.readline.split(':').last.split.map{|s| Integer(s, exception: false)}.compact
  $distances = f.readline.split(':').last.split.map{|s| Integer(s, exception: false)}.compact
end

def win?(total_time, distance_record, hold_time)
  time_left = total_time - hold_time
  travel = time_left * hold_time
  travel > distance_record
end

def solve
  time = $times.join.to_i
  distance_record = $distances.join.to_i
  puts time, distance_record

  # (48876981 - t) * t
  # Max is at 48876981 / 2
  # https://www.wolframalpha.com/input?i=the+maximum+point+of+%2848876981+-+t%29+*+t%2C+t%3D0..48876981

  # Roots for (48876981 - t) * t - 255128811171623 = 0
  # https://www.wolframalpha.com/input?i=roots+%2848876981+-+t%29+*+t+-+255128811171623+%3D+0%2C+t%3D0..48876981
  # t≈5942247
  # t≈42934734
  
  # puts (5942247-1..5942247+1).map{|t| [t, win?(time, distance_record, t)]}.to_s
  min = 5942248

  # puts (42934734-1..42934734+1).map{|t| [t, win?(time, distance_record, t)]}.to_s
  max = 42934733

  max - min + 1
end

read_input

solution = solve

puts solution
