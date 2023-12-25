# gem install networkx
require 'networkx'
# brew install graphviz
# gem install ruby-graphviz
require 'ruby-graphviz'
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
  # g = GraphViz.new(:G, :type => :graph)
  # nodes = $edges.flatten.uniq.to_h{|node| [ node, g.add_nodes(node) ] }
  # $edges.each do |from, to|
  #   g.add_edges(from, to, :label => "#{from}-#{to}")
  # end
  # g.output(:svg => 'graph.svg')
  # g.output(:png => 'graph.png')
  # For big input
  banned_edges = [
    %w[ljl xhg],
    %w[ffj lkm],
    %w[vgs xjb],
  ]
  # For small input
  # banned_edges = [
  #   %w[cmg bvb],
  #   %w[jqt nvd],
  #   %w[pzl hfx],
  # ]

  graph = NetworkX::Graph.new
  $edges.each do |from, to|
    graph.add_edge(from, to) unless banned_edges.include?([from, to])
  end

  res = NetworkX::singlesource_dijkstra(graph, $edges.first.first)
  s1 = res[0].size
  s2 = graph.number_of_nodes - s1
  puts s1, s2
  s1 * s2
end

read_input

solution = solve

puts solution
