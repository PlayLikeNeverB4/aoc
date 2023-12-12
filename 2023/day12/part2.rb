$records = nil
FACTOR = 5

def read_input
  f = File.open('input.txt', 'r')
  $records = f.readlines.map do |record|
    tokens = record.strip.split
    [([tokens[0]] * FACTOR).join('?'), tokens[1].split(',').map(&:to_i) * FACTOR]
  end
end

def solve_record(record)
  str, groups = record
  dp = Array.new(str.size + 1) { Array.new(groups.size + 1) { 0 } }
  dp[0][0] = 1
  for i in 0..str.size-1 do
    for j in 0..groups.size-1 do
      next if dp[i][j] == 0

      # Put .
      if str[i] != '#'
        dp[i + 1][j] += dp[i][j]
      end

      # we can start a new group at i (we know i-1 is not part of the group)
      # and make sure the groups ends with a . or the end of the string
      need_size = groups[j]
      if str.size - i >= need_size &&
         str[i..i+need_size-1].chars.all?{|c| c != '.'} &&
         (str.size - i == need_size || str[i + need_size] != '#')
        end_pos = [i + need_size + 1, str.size].min
        dp[end_pos][j + 1] += dp[i][j]
      end
    end
  end

  valid_ends_start = (str.rindex('#') || -1) + 1
  dp[valid_ends_start..].map{|row| row[groups.size]}.sum
end

def solve
  $records.map{|record| solve_record(record)}.sum
end

read_input

solution = solve

puts solution
