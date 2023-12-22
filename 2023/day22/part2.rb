$bricks = nil

def read_input
  f = File.open('input.txt', 'r')
  $bricks = f.readlines.map do |line|
    line.strip.split('~').map{|b| b.split(',').map(&:to_i)}.sort_by(&:last)
  end
end

def overlap_x?(a, b, c, d)
  a, b = b, a if a > b
  c, d = d, c if c > d
  left = [a, c].max
  right = [b, d].min
  left <= right
end

def overlap_xy?(b, nb)
  overlap_x?(b[0][0], b[1][0], nb[0][0], nb[1][0]) &&
    overlap_x?(b[0][1], b[1][1], nb[0][1], nb[1][1])
end

def visit_chain(bidx, visited, from, to)
  visited[bidx] = true
  above = (to[bidx] || []).filter{|idx| from[idx].all?{|ridx| visited[ridx] } && !visited[idx]}
  above.each do |idx|
    visit_chain(idx, visited, from, to)
  end
end

def solve
  answer = 0
  bs = $bricks.sort_by{|b| b[1][2] }
  max_z = bs.map{|b| b[1][2]}.max
  bricks_by_z = Array.new(max_z + 1) { [] }
  edges = []
  bs.each_with_index do |b, bidx|
    next_z = 0
    (0..b[0][2]-1).reverse_each do |z|
      bricks_by_z[z].each do |idx|
        nb = bs[idx]
        if overlap_xy?(b, nb)
          next_z = nb[1][2]
          break
        end
      end
      break if next_z > 0
    end
    bricks_by_z[next_z].each do |idx|
      nb = bs[idx]
      edges << [bidx, idx] if nb[1][2] == next_z && overlap_xy?(b, nb)
    end
    fall = b[0][2] - next_z - 1
    bricks_by_z[b[1][2]].delete(bidx)
    b[0][2] -= fall
    b[1][2] -= fall
    bricks_by_z[b[1][2]] << bidx
  end

  from = {}
  to = {}
  edges.each do |a, b|
    from[a] ||= []
    from[a] << b
    to[b] ||= []
    to[b] << a
  end

  (0..bs.size-1).each do |bidx|
    visited = {}
    visit_chain(bidx, visited, from, to)
    fall_count = visited.size - 1
    answer += fall_count
  end

  answer
end

read_input

solution = solve

puts solution
