p IO.read('in.txt')[..-2].split(',').sum{|t| t.bytes.reduce(0) {|s, c| (s + c) * 17 % 256 }}
