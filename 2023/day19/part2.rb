$workflows = nil
$parts = nil
ATTRIBUTES = 'xmas'
MAX_RANGE = 4000

def build_rule_range(rule)
  if rule[:condition][:operator] == '<'
    [1, rule[:condition][:value] - 1]
  else
    [rule[:condition][:value] + 1, MAX_RANGE]
  end
end

def read_input
  f = File.open('input.txt', 'r')

  $workflows = {}
  while !(line = f.readline.strip).empty?
    name, rules_str = line.split(/[{}]/)
    rules = rules_str.split(',').map do |rule_str|
      condition_str, destination = rule_str.split(':')
      if destination.nil?
        next {
          condition: nil,
          destination: condition_str,
        }
      end
      rule = {
        condition: {
          attribute: ATTRIBUTES.index(condition_str[0]),
          operator: condition_str[1],
          value: condition_str[2..].to_i,
        },
        destination: destination,
      }
      rule[:condition][:range] = build_rule_range(rule)
      rule
    end
    $workflows[name] = rules
  end

  $parts = []
  while !f.eof?
    part = f.readline.strip.split(/[{},]/).reject(&:empty?).map{|str| [ATTRIBUTES.index(str[0]), str[2..].to_i]}.sort.map(&:last)
    $parts << part
  end
end

def range_intersection(range1, range2)
  a, b = range1
  c, d = range2
  left = [a, c].max
  right = [b, d].min
  return [nil, range1] if left > right
  return [range1, nil] if left <= a && b <= right
  return [[left, b], [a, left - 1]] if left > a
  return [[a, right], [right + 1, b]] if right < b
  raise '???'
end

def ranges_intersect_rule(ranges, rule)
  return [rule[:destination], ranges, nil] if rule[:condition].nil?

  index = rule[:condition][:attribute]
  new_range, remaining_range = range_intersection(ranges[index], rule[:condition][:range])

  new_ranges = ranges.map(&:dup)
  new_ranges[index] = new_range
  new_ranges = nil if new_range.nil?

  remaining_ranges = ranges.map(&:dup)
  remaining_ranges[index] = remaining_range
  remaining_ranges = nil if remaining_range.nil?

  [rule[:destination], new_ranges, remaining_ranges]
end

def solve
  visited = {}
  queue = []
  start = ['in', [[1, MAX_RANGE], [1, MAX_RANGE], [1, MAX_RANGE], [1, MAX_RANGE]]]
  visited[start] = true
  queue << start
  while !queue.empty?
    workflow_name, ranges = queue.shift
    next if %w[A R].include?(workflow_name)

    $workflows[workflow_name].each do |rule|
      break if ranges.nil?
      next_destination, next_ranges, remaining_ranges = ranges_intersect_rule(ranges, rule)
      ranges = remaining_ranges
      next if next_ranges.nil?
      next_state = [next_destination, next_ranges]
      next if visited[next_state]
      visited[next_state] = true
      queue << next_state
    end
  end

  visited.keys.filter{|state| state[0] == 'A'}.map{|_, ranges| ranges.map{|a, b| b - a + 1}.inject(:*)}.sum
end

read_input

solution = solve

puts solution
