# gem install networkx
require 'networkx'
$edges = []

def read_input
  f = File.open('input.txt', 'r')
  f.readlines.each do |line|
    from, edge_str = line.strip.split(':')
    edge_str.split.each do |to|
      $edges << [from, to]
    end
  end
end

def solve
  graph = NetworkX::Graph.new
  $edges.each do |from, to|
    graph.add_edge(from, to)
  end

  # ruby doesn't have minimum_edge_cut :(
  # So I try to eliminate all pairs of edges and find the bridge
  # Takes a lot of time :D it never finished (left it for 1h)

  # puts $edges.size
  # banned_edges = []
  # $edges.combination(2).each do |e1, e2|
  #   graph.remove_edge(e1[0], e1[1])
  #   graph.remove_edge(e2[0], e2[1])
  #   bridges = NetworkX::bridges(graph)
  #   banned_edges += bridges
  #   graph.add_edge(e1[0], e1[1])
  #   graph.add_edge(e2[0], e2[1])
  #   break if banned_edges.size == 3
  # end

  # banned_edges.each do |from, to|
  #   graph.remove_edge(from, to)
  # end

  # res = NetworkX::singlesource_dijkstra(graph, $edges.first.first)
  # s1 = res[0].size
  # s2 = graph.number_of_nodes - s1
  # puts s1, s2
  # s1 * s2
end

read_input

solution = solve

puts solution
