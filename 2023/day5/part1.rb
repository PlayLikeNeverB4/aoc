require 'set'
$seeds = nil
$maps = []

def read_input
  f = File.open('input.txt', 'r')
  $seeds = f.readline.strip.split(':').last.split.map(&:to_i)
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

def map_get(map, x)
  map.each do |dest, src, size|
    next if !x.between?(src, src + size - 1)
    return dest + x - src
  end
  x
end

def solve
  $seeds.map do |seed|
    $maps.each do |map|
      seed = map_get(map, seed)
    end
    seed
  end.min
end

read_input

solution = solve

puts solution
