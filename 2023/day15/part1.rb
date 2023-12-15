puts File.open('input.txt').readline.strip.split(',').sum{|s| s.chars.reduce(0) { |sum, c| (sum + c.ord) * 17 % 256 } }
