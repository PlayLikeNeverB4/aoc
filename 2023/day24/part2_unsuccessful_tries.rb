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
  if ta != tb
    return nil
  end
  t = ta

  [x, y, t]
end

def point_in_time(p, t)
  (0..p[0].size-1).map{|d| p[0][d] + t * p[1][d] }
end

def check_solution(pos, v, dims)
  p0 = [pos, v]
  $points.all? do |p|
    x, y, t = intersection_time(p0, p)
    next false if x.nil? || t < 0
    np0 = point_in_time(p0, t)
    np = point_in_time(p, t)
    if np0[dims] != np[dims]
      # puts np.to_s
      # puts np0.to_s
      next false
    end
    true
  end
end

def solve_case_xy(a, t0, b, t1)
  pa = a.map(&:dup)
  pb = b.map(&:dup)
  pa[0][0] += pa[1][0] * t0
  pa[0][1] += pa[1][1] * t0
  pa[0][2] += pa[1][2] * t0

  pb[0][0] += pb[1][0] * (t0 + t1)
  pb[0][1] += pb[1][1] * (t0 + t1)
  pb[0][2] += pb[1][2] * (t0 + t1)

  vx = (pb[0][0] - pa[0][0]).to_f / t1
  vy = (pb[0][1] - pa[0][1]).to_f / t1
  vz = (pb[0][2] - pa[0][2]).to_f / t1

  x0 = pa[0][0] - vx * t0
  y0 = pa[0][1] - vy * t0
  z0 = pa[0][2] - vz * t0

  p0 = [x0, y0, z0]
  v = [vx, vy, vz]

  # puts "p0 = #{p0}"
  # puts "v = #{v}"
  all_ok = check_solution(p0, v)

  return nil if !all_ok

  [p0, v]
end

def brute_solve
  # puts solve_case_xy($points[4], 1, $points[1], 3).to_s
  # puts solve_case_xy($points[4], 1, $points[1], 2).to_s
  # return 0

  point_count = $points.size
  # point_count = 3
  max_initial_delta = 100
  v_range = (-100..100)
  # max_delta = 100

  $points.each do |a|
    puts "Trying #{a}"
    v_range.to_a.repeated_permutation(2) do |vx|
    # v_range.to_a do |vx|
    # a = $points[4]
    # v = [-3, 1, 2]
      v = [vx[0], vx[1], 0]
      (1..max_initial_delta).each do |t0|
        p = point_in_time(a, t0)
        # puts p.to_s
        p = point_in_time([p, v], -t0)
        # puts p.to_s
        ok = check_solution(p, v, 0..1)
        next if !ok
        puts "#{a} #{v} => #{p}"
        return p
      end
    end
  end

  # point_count = $points.size
  # # point_count = 3
  # max_initial_delta = 100
  # max_delta = 100

  # points = $points
  # points = points[0..point_count-1]
  # # points = $points
  # # $points.shuffle!

  # points.combination(3).each do |pts|
  #   $points = pts
  #   (0..$points.size-1).to_a.permutation(2).each do |aidx, bidx|
  #     a = $points[aidx]
  #     b = $points[bidx]
  #     # puts "#{aidx} #{bidx}"
  #     puts aidx if bidx == 0

  #     (0..max_initial_delta).each do |t0|
  #       # puts t0
  #       (1..max_delta).each do |t1|
  #         # puts t1
  #         pt = solve_case_xy(a, t0, b, t1)
  #         next if pt.nil?
  #         puts "#{a} #{b} #{t0} #{t1} => #{pt}"
  #         return pt
  #       end
  #     end
  #   end
  # end
  0
end


def overlap_x?(a, b, c, d)
  a, b = b, a if a > b
  c, d = d, c if c > d
  left = [a, c].max
  right = [b, d].min
  left <= right
end

def solve_case(a, t0, b, t1)
  pa = a.map(&:dup)
  pb = b.map(&:dup)
  pa[0][0] += pa[1][0] * t0
  pa[0][1] += pa[1][1] * t0
  pa[0][2] += pa[1][2] * t0
  pb[0][0] += pb[1][0] * t1
  pb[0][1] += pb[1][1] * t1
  pb[0][2] += pb[1][2] * t1
end


def solve
  # puts check_solution([24, 13, 10], [-3, 1, 2])
  # return 0

  return brute_solve

  # puts (0..2).map{|c| $points.map{|p| p[0][c]}.minmax}
  # return 0

  # https://csacademy.com/app/geometry_widget
  # $points.each do |p|
  #   puts "Segment #{p[0][0].to_f / 525394990446403} #{p[0][1].to_f / 539640298481149} #{(p[0][0] + 525394990446403 * p[1][0]).to_f / 525394990446403} #{(p[0][1] + 539640298481149 * p[1][1]).to_f / 539640298481149}"
  # end
  # return 0

  max_initial_time = 10
  max_delta_time = 10
  $points.combination(2).each do |a, b|
    (1..max_initial_time).each do |t0|
      (1..max_delta_time).each do |t1|
        pt = solve_case_x(a, t0, b, t1)
        next if pt.nil?
        puts pt.to_s
        # return pt
      end
    end

    # puts a.to_s
    # puts b.to_s

    # a1 = a[1][1]
    # b1 = -a[1][0]
    # c1 = a1 * a[0][0] + b1 * a[0][1]
    # a2 = b[1][1]
    # b2 = -b[1][0]
    # c2 = a2 * b[0][0] + b2 * b[0][1]
    # x, y = intersection(a1, b1, c1, a2, b2, c2)
    # if !x.nil? && !y.nil? && x.between?(MIN, MAX) && y.between?(MIN, MAX)
    #   if (x > a[0][0]) != (a[1][0] > 0) || (x > b[0][0]) != (b[1][0] > 0)
    #     next
    #   end
    #   answer += 1
    #   next
    # end

    # next if !x.nil? && !y.nil?
  end
  answer
end

read_input

solution = solve

puts solution
