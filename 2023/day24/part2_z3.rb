# brew install z3
# gem install z3
require 'z3'

$points = nil

def read_input
  f = File.open('input.txt', 'r')
  $points = f.readlines.map{|line| line.split('@').map{|pts| pts.split(',').map(&:to_i)}}
end

def solve
  solver = Z3::Solver.new
  p0 = (0..2).map{|d| Z3::Int("p0#{d}")}
  v = (0..2).map{|d| Z3::Int("v#{d}")}
  t = (0..2).map{|d| Z3::Int("t#{d}")}

  (0..2).each do |i|
    3.times do |d|
      solver.assert p0[d] + t[i] * v[d] == $points[i][0][d] + t[i] * $points[i][1][d]
    end
  end

  puts 'Running solver...'
  railse 'no solutions' unless solver.satisfiable?
  res = solver.model.to_a.map(&:last).map(&:to_i)
  puts res.to_s

  res.first(3).sum
end

read_input

solution = solve

puts solution
