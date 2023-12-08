require 'set'
$directions = nil
$graph = nil

def card_value(c)
  if c.between?('2', '9') then c.ord - '0'.ord
  elsif c == 'T' then 10
  elsif c == 'J' then 11
  elsif c == 'Q' then 12
  elsif c == 'K' then 13
  elsif c == 'A' then 14
  else raise('wtf') end
end

def read_input
  f = File.open('input.txt', 'r')
  $directions = f.readline.strip
  f.readline
  $graph = {}
  f.readlines.each do |line|
    tokens = line.split('=')
    crt = tokens.first.strip
    edges = tokens.last.strip[1..-2].split(',').map(&:strip)
    $graph[crt] = edges
  end
end

def solve
  steps = 0
  node = 'AAA'
  direction_index = 0
  while node != 'ZZZ'
    edge_index = 'LR'.index($directions[direction_index])
    node = $graph[node][edge_index]
    direction_index = (direction_index + 1) % $directions.size
    steps += 1
  end
  steps
end

read_input

solution = solve

puts solution
