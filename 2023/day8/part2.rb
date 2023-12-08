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

def combine_cycles(cycles)
  cycle_len, end_level0 = cycles.first
  steps = end_level0
  while true
    if cycles.all?{|_, end_level| steps >= end_level}
      if cycles.all?{|cycle_len, end_level| (steps - end_level) % cycle_len == 0}
        break
      end
    end
    steps += cycle_len
  end
  [cycles.map(&:first).reduce(1, :lcm), steps]
end

def solve
  queue = Set.new($graph.select{|node, edges| node.end_with?('A')}.map(&:first))
  end_nodes = Set.new($graph.select{|node, edges| node.end_with?('Z')}.map(&:first))
  puts "End nodes: #{end_nodes.to_s}"
  steps = 0
  direction_index = 0

  # Brute force takes too long because long cycles
  # while end_nodes.intersection(queue).size != queue.size
  #   edge_index = 'LR'.index($directions[direction_index])
  #   # puts queue.to_s
  #   queue = Set.new(queue.map do |node|
  #     $graph[node][edge_index]
  #   end)
  #   direction_index = (direction_index + 1) % $directions.size
  #   steps += 1
  # end

  # lol each cycle has only 1 end node
  cycles = queue.map do |initial_node|
    steps = 0
    direction_index = 0
    visited = {}
    ends = 0
    node = initial_node
    end_level = nil
    node_levels = {}
    level = 0
    while visited[[node, direction_index]].nil?
      edge_index = 'LR'.index($directions[direction_index])
      visited[[node, direction_index]] = true
      node_levels[[node, direction_index]] = level
      node = $graph[node][edge_index]
      direction_index = (direction_index + 1) % $directions.size
      steps += 1
      level += 1
      if node.end_with?('Z')
        ends += 1 
        end_level = level
      end
      # puts node
    end
    puts "Repeating level: #{node_levels[[node, direction_index]]}"
    puts "End level: #{end_level}"
    puts [steps, ends].join(' ')
    cycle_len = steps - node_levels[[node, direction_index]]
    [cycle_len, end_level]
  end

  puts cycles.to_s

  c = cycles[0]
  (1..cycles.size-1).each do |cycle|
    c = combine_cycles([c, cycles[cycle]])
  end
  puts c.to_s

  c[1]
end

read_input

solution = solve

puts solution
