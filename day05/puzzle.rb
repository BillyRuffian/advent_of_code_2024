require 'tsort'

r, o = File.read('input.txt').split("\n\n")

class Hash
  include TSort

  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node, []).each(&block)
  end
end

rules = r.split("\n").inject(Hash.new { |h, k| h[k] = [] }) do |memo, line|
  value, key = line.chomp.split('|')
  memo[key] << value
  memo
end

orderings = o.split("\n").map { |line| line.split(',') }

puts 'Part 1'

result = orderings.map do |ordering|
  subset_rule = rules.select { |k, _| ordering.include?(k) }
  correct_order = subset_rule.tsort.filter { |k| ordering.include?(k) }
  if correct_order == ordering
    ordering[ordering.size / 2].to_i
  else
    0
  end
end

pp result.sum

puts 'Part 2'

result = orderings.filter_map do |ordering|
  subset_rule = rules.select { |k, _| ordering.include?(k) }
  correct_order = subset_rule.tsort.filter { |k| ordering.include?(k) }
  correct_order[ordering.size / 2].to_i if correct_order != ordering
end

pp result.sum
