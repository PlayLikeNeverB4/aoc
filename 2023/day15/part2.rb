boxes = {}
IO.read('in.txt')[..-2].split(',').map do |step|
  label, val = step.split(/[=-]/)
  idx = label.bytes.reduce(0) {|s, c| (s + c) * 17 % 256 }
  box = boxes[idx] ||= {}
  box[label] = [
    box.dig(label, 1) && box.dig(label, 0) || ((box.values.map(&:first).max || 0) + 1),
    val
  ]
end
p (boxes.sum do |box_idx, box|
  box.values.sort.map(&:last).compact.each_with_index.sum do |val, lens_idx|
    (box_idx + 1) * (lens_idx + 1) * val.to_i
  end
end)
