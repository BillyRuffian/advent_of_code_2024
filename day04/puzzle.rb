SEARCH_WORD = 'XMAS'.freeze
# create a grid of directions to follow while searching
DIRECTIONS = (-1..1).to_a.product((-1..1).to_a).reject { |x, y| x.zero? && y.zero? }

grid = File.readlines('input.txt', chomp: true).map(&:chars)

puts 'Part 1'

found = grid.each_with_index.sum do |row, y|
  row.each_with_index.sum do |_cell, x|
    DIRECTIONS.count do |dx, dy|
      SEARCH_WORD.chars.each_with_index.all? do |target_char, idx|
        next_x = x + dx * idx
        next_y = y + dy * idx
        next false if next_y.negative? || next_x.negative?
        next false if next_y >= grid.size || next_x >= row.size

        target_char == grid[y + dy * idx][x + dx * idx]
      end
    end
  end
end

pp found

puts 'Part 2'
# I'm going to find the centre of the pattern by finding 'A' and then
# seeing if it forms the patterns of 'MAS' forwards, backwords or diagnoally

SEARCH_DIRECTIONS = [-1, 1].product([-1, 1])
MATCHING_X_MAS_PATTERNS = %w[MSMS SMSM MMSS SSMM].map(&:chars)

found = grid.each_with_index.sum do |row, y|
  row.each_with_index.count do |cell, x|
    next false if y.zero? || y == grid.size - 1
    next false if x.zero? || x == row.size - 1
    next false unless cell == 'A'

    patterns = SEARCH_DIRECTIONS.map do |dy, dx|
      grid[y + dy][x + dx]
    end
    MATCHING_X_MAS_PATTERNS.include?(patterns.filter { |letter| letter =~ /[MS]/ })
  end
end

pp found
