text = File.new('input.txt').read.chomp

puts 'Part 1'
result = text
  .scan(/mul\((\d+),(\d+)\)/)
  .sum { |a, b|  a.to_i * b.to_i }
puts result

puts 'Part 2'

enabled = true
result = text
  .scan(/(do)\(\)|(don't)\(\)|(mul\(\d+,\d+\))/)
  .flatten
  .compact
  .inject(0) do |memo, op|
    case op
    when 'do'
      enabled = true
    when "don't"
      enabled = false
    when /mul\(\d+,\d+\)/
      memo += op.scan(/\d+/).map(&:to_i).reduce(:*) if enabled
    end
    memo
  end

pp result
