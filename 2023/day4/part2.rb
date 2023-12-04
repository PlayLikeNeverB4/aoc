require 'set'
$cards = nil

def read_input
  f = File.open('input.txt', 'r')
  $cards = f.map{|line| line.split(':').last.split('|').map{|side| side.strip.split.map(&:to_i) }}
end

def solve
  winnings = Array.new($cards.size)
  $cards.each_with_index.reverse_each do |cs, index|
    matches = cs[0].to_set.intersection(cs[1].to_set).size
    winnings[index] = 1 + (winnings[index+1..index+matches] || []).sum
  end
  winnings.sum
end

read_input

solution = solve

puts solution
