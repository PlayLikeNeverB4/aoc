$bricks = nil

def read_input
  f = File.open('input.txt', 'r')
  $bricks = f.readlines.map do |line|
    line.strip.split('~').map{|b| b.split(',').map(&:to_i)}.sort_by(&:last)
  end.sort_by{|b| b[1][2] }
end

def overlap_x?(a, b, c, d)
  a, b = b, a if a > b
  c, d = d, c if c > d
  left = [a, c].max
  right = [b, d].min
  left <= right
end

def overlap_xy?(b, nb)
  !overlap_x?(b[0][2], b[1][2], nb[0][2], nb[1][2]) &&
  overlap_x?(b[0][0], b[1][0], nb[0][0], nb[1][0]) &&
    overlap_x?(b[0][1], b[1][1], nb[0][1], nb[1][1])
end

def solve
  answer = 0
  bs = $bricks
  edges = []
  bs.each_with_index do |b, bidx|
    next_z = 0
    bs.first(bidx).each do |nb|
      next_z = [next_z, nb[1][2]].max if overlap_xy?(b, nb)
    end
    bs.first(bidx).each_with_index do |nb, idx|
      edges << [bidx, idx] if nb[1][2] == next_z && overlap_xy?(b, nb)
    end
    fall = b[0][2] - next_z - 1
    b[0][2] -= fall
    b[1][2] -= fall
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
    all_above = (to[bidx] || []).filter{|idx| from[idx].size == 1}
    answer += 1 if all_above.empty?
  end

  answer
end

read_input

solution = solve

puts solution
