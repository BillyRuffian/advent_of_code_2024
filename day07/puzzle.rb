equations = File
  .new('input.txt')
  .readlines(chomp: true)
  .map { _1.split(/: | /) }
  .map { _1.map(&:to_i) }

module IntegerConcatenation
  refine Integer do
    def concat(other)
      "#{self}#{other}".to_i
    end
  end
end

using IntegerConcatenation

puts 'Part 1'

def solve(equations, ops)
  equations.filter_map do |values|
    target = values[0]
    starting_value = values[1]
    possible_results = values
      .drop(2)
      .inject([starting_value]) do |memo, value|
        memo.flat_map { |v| ops.map { |op| v.send(op, value) } }
      end
    target if possible_results.include?(target)
  end
end

pp solve(equations, %i[+ *]).sum

puts 'Part 2'
pp solve(equations, %i[+ * concat]).sum
