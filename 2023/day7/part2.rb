require 'set'
$hand_bids = nil

FIVE_OF_A_KIND = 6
FOUR_OF_A_KID = 5
FULL_HOUSE = 4
THREE_OF_A_KIND = 3
TWO_PAIR = 2
ONE_PAIR = 1
HIGH_CARD = 0

JOKER = 11

def card_value(c)
  if c.between?('2', '9') then c.ord - '0'.ord
  elsif c == 'T' then 10
  elsif c == 'J' then 11
  elsif c == 'Q' then 12
  elsif c == 'K' then 13
  elsif c == 'A' then 14
  else raise('wtf') end
end

def read_input
  f = File.open('input.txt', 'r')
  $hand_bids = f.readlines.map do |line|
    tokens = line.split
    [
      tokens.first.strip.chars.map{|c| card_value(c)},
      tokens.last.to_i,
    ]
  end
end

def hand_type(hand)
  matches = hand.tally.sort_by(&:last).reverse.map(&:last)
  if matches[0] == 5 then FIVE_OF_A_KIND
  elsif matches[0] == 4 then FOUR_OF_A_KID
  elsif matches[0] == 3
    if matches[1] == 2 then FULL_HOUSE else THREE_OF_A_KIND end
  elsif matches[0] == 2
    if matches[1] == 2 then TWO_PAIR else ONE_PAIR end
  else HIGH_CARD end
end

def joker_hand_type(hand)
  joker_indices = hand.each_index.select{|i| hand[i] == JOKER}
  (2..14).to_a.repeated_permutation(joker_indices.size).map do |joker_values|
    crt_hand = hand.dup
    joker_indices.each_with_index{|joker_idx, idx| crt_hand[joker_idx] = joker_values[idx]}
    hand_type(crt_hand)
  end.max
end

def comparison_values(hand)
  hand.map{|c| if c == JOKER then 0 else c end}
end

def solve
  sorted_hands = $hand_bids.sort_by do |hand, bid|
    [joker_hand_type(hand), comparison_values(hand)]
  end
  sorted_hands.each_with_index.map{|hand_bid, index| hand_bid.last * (index + 1)}.sum
end

read_input

solution = solve

puts solution
