$workflows = nil
$parts = nil

def read_input
  f = File.open('input.txt', 'r')

  $workflows = {}
  while !(line = f.readline.strip).empty?
    name, rules_str = line.split(/[{}]/)
    rules = rules_str.split(',').map do |rule_str|
      condition_str, destination = rule_str.split(':')
      if destination.nil?
        next {
          condition: nil,
          destination: condition_str,
        }
      end
      {
        condition: {
          attribute: condition_str[0],
          operator: condition_str[1],
          value: condition_str[2..].to_i,
        },
        destination: destination,
      }
    end
    $workflows[name] = rules
  end

  $parts = []
  while !f.eof?
    part = f.readline.strip.split(/[{},]/).reject(&:empty?).map{|str| [str[0], str[2..].to_i]}.to_h
    $parts << part
  end
end

def check_condition(part, cond)
  part[cond[:attribute]].send(cond[:operator], cond[:value])
end

def run_workflow(part, workflow)
  workflow.each do |rule|
    return rule[:destination] if rule[:condition].nil?
    return rule[:destination] if check_condition(part, rule[:condition])
  end
  raise 'not found match'
end

def run_workflows(part)
  crt = 'in'
  while !%w[A R].include?(crt)
    crt = run_workflow(part, $workflows[crt])
  end
  crt
end

def solve
  $parts.filter{|part| run_workflows(part) == 'A'}.map{|part| part.values.sum}.sum
end

read_input

solution = solve

puts solution
