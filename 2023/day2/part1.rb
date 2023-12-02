$games = nil
MAX_CUBES = {
  'red' => 12,
  'green' => 13,
  'blue' => 14,
}.freeze

def read_input
  f = File.open('input.txt', 'r')
  $games = f.map do |line|
    tokens = line.strip.split(':')
    game_id = tokens[0].split.last.to_i
    sets = tokens[1].split(';').map do |set|
      set.split(',').map do |die|
        count, type = die.split.map(&:strip)
        [type, count.to_i]
      end.to_h
    end
    raise line if sets.any?{|set| set.size > 3}

    {
      id: game_id,
      sets: sets,
    }
  end
end

def write_output(sol)
  f = File.open('output.txt', 'w')
  f.puts(sol)
  f.close
end

def solve
  $games.select{|game| game[:sets].all?{|set| set.all?{|type, count| count <= MAX_CUBES[type] }}}.sum{|game| game[:id]}
end

read_input

solution = solve

write_output(solution)
