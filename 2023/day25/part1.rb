require 'set'
$graph = nil
$nodes = nil
$edges = {}

def read_input
  f = File.open('input.txt', 'r')
  graph = {}
  nodes = []
  f.readlines.each do |line|
    from, edge_str = line.strip.split(':')
    edge_str.split.each do |to|
      graph[from] ||= []
      graph[from] << to
      graph[to] ||= []
      graph[to] << from
      nodes << from << to
      $edges[[from, to]] = true
      $edges[[to, from]] = true
      # puts "#{from}-#{to}"
    end
  end
  $graph = graph
  $nodes = nodes.uniq
end

def bfs(start_node, banned_edges)
  queue = []
  visited = {}
  nodes = []
  queue << start_node
  nodes << start_node
  visited[start_node] = true
  prev = {}

  while !queue.empty?
    node = queue.shift
    $graph[node].each do |next_node|
      next if visited[next_node]
      next if banned_edges[[node, next_node]]
      queue << next_node
      nodes << next_node
      visited[next_node] = true
      prev[next_node] = node
    end
  end

  path = []
  if nodes.size == $nodes.size
    node = nodes.last
    while node != start_node
      path << node
      node = prev[node]
    end
    path << start_node
    path = path.reverse
  else
    path = nil
  end

  [ nodes, path ]
end

def solve
  start_node = $nodes.first
  nodes, _ = bfs(start_node, {})
  end_node = nodes.last
  nodes, _ = bfs(end_node, {})
  start_node = nodes.last

  # puts "start = #{start_node}"
  # puts "end = #{end_node}"

  banned_edges = {}
  3.times do
    _, path = bfs(start_node, banned_edges)
    # puts "Path: #{path}"
    # puts path[path.size / 3 .. path.size * 2 / 3].to_s
    (path.size/3..path.size*2/3).each do |idx|
      banned_edges[[path[idx], path[idx + 1]]] = true
      banned_edges[[path[idx + 1], path[idx]]] = true
    end
    # puts banned_edges.to_s
  end

  nodes, path = bfs(start_node, banned_edges)
  raise 'not disconnected' if !path.nil?

  s1 = nodes.size
  s2 = $nodes.size - s1
  puts s1, s2
  s1 * s2
end

read_input

solution = solve

puts solution
