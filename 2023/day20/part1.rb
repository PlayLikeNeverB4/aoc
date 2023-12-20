$edges = {}
$node_types = {}
NORMAL = 0
FLIP_FLOP = 1
CONJUNCTION = 2
DEBUG = false

def read_input
  f = File.open('input.txt', 'r')

  f.readlines.each do |line|
    nodes = line.strip.split(' -> ')
    source_node = nodes[0]
    node_type = NORMAL
    if source_node.start_with?('%')
      source_node = source_node[1..]
      node_type = FLIP_FLOP
    elsif source_node.start_with?('&')
      source_node = source_node[1..]
      node_type = CONJUNCTION
    end
    destination_nodes = nodes[1].split(/[, ]/).reject(&:empty?)
    $node_types[source_node] = node_type
    $edges[source_node] = destination_nodes
  end
end

def simulate_button(node_states)
  puts 'SIMULATION =====' if DEBUG
  low_count = 1
  high_count = 0
  queue = []
  $edges['broadcaster'].each do |node|
    queue << [ node, 0, 'broadcaster' ]
  end

  while !queue.empty?
    node, p, from = queue.shift
    low_count += 1 if p == 0
    high_count += 1 if p == 1

    puts "Processing #{node}, #{p}, #{from}" if DEBUG

    if $node_types[node] == FLIP_FLOP
      if p == 0
        node_states[node] = 1 - node_states[node]
        puts "Sending #{node_states[node]} to edges" if DEBUG
        $edges[node].each do |next_node|
          queue << [ next_node, node_states[node], node ]
        end
      end
    elsif $node_types[node] == CONJUNCTION
      node_states[node][from] = p
      pulse_type = if node_states[node].all?{|_, p| p == 1} then 0 else 1 end
      puts "Sending #{pulse_type} to edges" if DEBUG
      $edges[node].each do |next_node|
        queue << [ next_node, pulse_type, node ]
      end
    else
      # output module, ignore
    end
  end

  [ node_states, low_count, high_count ]
end

def solve
  node_states = {}
  $node_types.each do |node, type|
    if type == FLIP_FLOP
      # flip = initially off
      node_states[node] = 0
    elsif type == CONJUNCTION
      # conj = initially next is high
      node_states[node] = {}
    end
  end
  $edges.each do |from, nodes|
    nodes.each do |to|
      if $node_types[to] == CONJUNCTION
        node_states[to][from] = 0
      end
    end
  end

  puts $edges.to_s
  puts $node_types.to_s
  puts node_states.to_s

  total_low = 0
  total_high = 0
  1000.times do
    node_states, low_count, high_count = simulate_button(node_states)
    total_low += low_count
    total_high += high_count
  end
  
  puts total_high, total_low
  total_low * total_high
end

read_input

solution = solve

puts solution
