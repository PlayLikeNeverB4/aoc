$sequences = nil

def read_input
  f = File.open('input.txt', 'r')
  $sequences = f.readlines.map{|line| line.strip.split.map(&:to_i)}
end

def predict_next(seq)
  return 0 if seq.all?(&:zero?)
  diffs = (0..seq.size-2).map{|idx| seq[idx + 1] - seq[idx]}
  seq.last + predict_next(diffs)
end

def solve
  $sequences.map{|seq| predict_next(seq)}.sum
end

read_input

solution = solve

puts solution
