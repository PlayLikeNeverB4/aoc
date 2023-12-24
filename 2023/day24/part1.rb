$points = nil

def read_input
  f = File.open('input.txt', 'r')
  $points = f.readlines.map{|line| line.split('@').map{|pts| pts.split(',').map(&:to_i)}}
end

MIN = 200000000000000# - 1e-6
MAX = 400000000000000# + 1e-6
# MIN = 7
# MAX = 27

def intersection(a1, b1, c1, a2, b2, c2)
  det = a1 * b2 - a2 * b1
  if det == 0
    puts 'this!!'
    return nil
  else
    x = (b2 * c1 - b1 * c2).to_f / det
    y = (a1 * c2 - a2 * c1).to_f / det
    return [ x , y ]
  end
end

def intersection_time(a, b)
  a1 = a[1][1]
  b1 = -a[1][0]
  c1 = a1 * a[0][0] + b1 * a[0][1]
  a2 = b[1][1]
  b2 = -b[1][0]
  c2 = a2 * b[0][0] + b2 * b[0][1]
  x, y = intersection(a1, b1, c1, a2, b2, c2)
  return nil if x.nil?

  ta = (x - a[0][0]).to_f / a[1][0]
  tb = (x - b[0][0]).to_f / b[1][0]
  t = [ta, tb].min

  [x, y, t]
end

def solve
  answer = 0
  $points.combination(2).each do |a, b|
    # puts a.to_s
    # puts b.to_s

    x, y, t = intersection_time(a, b)
    if !x.nil? && !y.nil? && x.between?(MIN, MAX) && y.between?(MIN, MAX)
      if t < 0
        next
      end
      
      answer += 1
      next
    end

    next if !x.nil? && !y.nil?
    puts '???'
  end
  answer
end

read_input

solution = solve

puts solution
