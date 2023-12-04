require 'set'
$cards = nil

def read_input
  f = File.open('input.txt', 'r')
  $cards = f.map{|line| line.split(':').last.split('|').map{|side| side.strip.split.map(&:to_i) }}
end

def solve
  $cards.sum do |cs|
    matches = cs[0].to_set.intersection(cs[1].to_set).size
    next 0 if matches == 0
    2 ** (matches - 1)
  end
end

read_input

solution = solve

puts solution
