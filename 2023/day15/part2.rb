$steps = nil

def read_input
  f = File.open('in.txt', 'r')
  $steps = f.readline.strip.split(',').map do |step|
    tokens = step.split(/[=-]/)
    tokens[0] = tokens[0].chars
    tokens[1] = tokens[1].to_i if tokens.size > 1
    tokens
  end
end

def hash(str)
  str.reduce(0) {|sum, c| (sum + c.ord) * 17 % 256 }
end

def solve
  boxes = {}
  $steps.each do |label, value|
    idx = hash(label)
    boxes[idx] ||= {}
    if value.nil?
      boxes[idx].delete(label)
    else
      boxes[idx][label] = [
        boxes[idx].dig(label, 0) || ((boxes[idx].map{|_, data| data.first}.max || 0) + 1),
        value
      ]
    end
  end
  boxes.sum do |box_idx, box|
    box.sort_by(&:last).each_with_index.sum do |entry, lens_idx|
      label = entry[0]
      value = entry[1][1]
      (box_idx + 1) * (lens_idx + 1) * value
    end
  end
end

read_input

solution = solve

puts solution
