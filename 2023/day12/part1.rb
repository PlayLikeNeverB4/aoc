$records = nil

def read_input
  f = File.open('input.txt', 'r')
  $records = f.readlines.map do |record|
    tokens = record.strip.split
    [tokens[0], tokens[1].split(',').map(&:to_i)]
  end
end

def record_groups(record)
  record.split('.').reject(&:empty?).map(&:size)
end

def record_is_ok?(record, groups)
  record_groups(record) == groups
end

def solve_record(record)
  positions = record[0].size.times.select{|idx| record[0][idx] == '?'}
  ok = %w[. #].repeated_permutation(positions.size).select do |comb|
    fixed_record = record[0]
    positions.each_with_index do |pos, idx|
      fixed_record[pos] = comb[idx]
    end
    record_is_ok?(fixed_record, record[1])
  end
  ok.size
end

def solve
  $records.map{|record| solve_record(record)}.sum
end

read_input

solution = solve

puts solution
