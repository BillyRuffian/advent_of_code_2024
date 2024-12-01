lines = File
  .new('input.txt')
  .readlines(chomp: true)
  .map { _1.split(/\s+/) }

column1 = lines.map { _1[0].to_i }.sort
column2 = lines.map { _1[1].to_i }.sort

part1 = column1.zip(column2).inject(0) do |memo, (a, b)|
  memo + (a-b).abs
end

puts 'Part 1'
puts part1

tally = column2.tally

part2 = column1.inject(0) do |memo, a|
  memo + (a * (tally[a] || 0))
end

puts 'Part 2'
puts part2
