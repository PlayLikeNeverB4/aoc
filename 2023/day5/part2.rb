require 'set'
$seeds = nil
$maps = []

def read_input
  f = File.open('input.txt', 'r')
  $seeds = f.readline.strip.split(':').last.split.map(&:to_i).each_slice(2).to_a
  f.readline
  while !f.eof?
    f.readline # Ignore map name, assume they are sequential
    map = []
    while !f.eof? && !(line = f.readline.strip).empty?
      entry = line.split.map(&:to_i)
      map << entry
    end
    $maps << map if map.size > 0
  end
end

def range_intersection(a1, b1, a2, b2)
  st = [a1, a2].max
  dr = [b1, b2].min
  return nil if st > dr
  [st, dr]
end

def map_range(range, map_range)
  a, size1 = range
  dest, src, size2 = map_range
  
  match = range_intersection(a, a + size1 - 1, src, src + size2 - 1)
  return nil if match.nil?
  [
    match[0], match[1],
    dest + match[0] - src,
    match[1] - match[0] + 1,
  ]
end

def uncovered_range_parts(range, subranges)
  return [[range[0], range[1]]] if subranges.empty?
  a, size = range
  b = a + size - 1
  subranges.sort!
  res = []
  res << [a, subranges.first.first - 1] if a < subranges.first.first
  res << [subranges.last.last + 1, b] if subranges.last.last < b
  (0..subranges.size-2).each do |idx|
    res << [subranges[idx].last + 1, subranges[idx + 1].first - 1] if subranges[idx].last + 1 < subranges[idx + 1].first
  end
  res.map{|a, b| [a, b - a + 1]}
end

# ranges = list of pairs
def map_get(map, ranges)
  ranges.flat_map do |range|
    subranges = []
    mapped_range_parts = map.filter_map do |map_range|
      res = map_range(range, map_range)
      next nil if res.nil?
      s1, s2, r1, r2 = res
      subranges << [s1, s2]
      [r1, r2]
    end
    mapped_range_parts += uncovered_range_parts(range, subranges)

    mapped_range_parts
  end
end

def solve
  $seeds.map do |seed|
    seed = [seed]
    $maps.each do |map|
      seed = map_get(map, seed)
    end
    seed.map(&:first).min
  end.min
end

read_input

solution = solve

puts solution
