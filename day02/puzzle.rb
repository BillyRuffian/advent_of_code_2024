MAX_DELTA = 3
lines = File.new('input.txt').readlines(chomp: true).map { |l| l.split.map(&:to_i) }

puts 'Part 1'
def safe(reports)
  reports.each_cons(2).all? { |a, b| a > b && (a - b).abs <= MAX_DELTA } ||
    reports.each_cons(2).all? { |a, b| a < b && (a - b).abs <= MAX_DELTA }
end

safe_levels = lines.filter { |line| safe(line) }

pp safe_levels.count

puts 'Part 2'
safe_levels = lines.filter do |line|
  line.combination(line.count - 1).any? { |combo| safe(combo) }
end


pp safe_levels.count
