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

def gen_init_node_states
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
  node_states
end

def simulate_button(node_states, start_node, end_node, end_pulse)
  puts 'SIMULATION =====' if DEBUG
  queue = []
  queue << [ start_node, 0, 'broadcaster' ]
  end_reached = false

  while !queue.empty?
    node, p, from = queue.shift
    end_reached = true if p == end_pulse && node == end_node

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

  [ node_states, end_reached ]
end

def run_branch_until(start_node, end_node, end_pulse)
  node_states = gen_init_node_states
  button_presses = 0
  reached_count = 0
  while true do
    button_presses += 1
    node_states, end_reached = simulate_button(node_states, start_node, end_node, end_pulse)
    reached_count += 1 if end_reached
    # puts "reached in #{button_presses} presses" if end_reached
    break if reached_count > 0 # tested with > 3 to see cycle lengths
  end
  # puts "reached in #{button_presses} presses"
  button_presses
end

def solve
  # Visualizing the graph https://graphonline.ru/en/create_graph_by_edge_list
  # $edges.each do |from, nodes|
  #   nodes.each do |to|
  #     puts "#{from}>#{to}"
  #   end
  # end

  # rx = 0 <=> zh = 1
  # Treat each broadcaster branch independently and see when they align
  # All of them have the same initial steps as their cycle lengths, so just lcm

  node_states = gen_init_node_states
  $edges['broadcaster'].map{|branch| run_branch_until(branch, 'zh', 1) }.reduce(1, :lcm)
end

read_input

solution = solve

puts solution
