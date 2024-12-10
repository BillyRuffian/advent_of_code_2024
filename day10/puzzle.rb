require 'matrix'

DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1]].map { |x, y| Vector[x, y] }.freeze

grid = File.new('input.txt')
  .readlines(chomp: true)
  .map(&:chars)
  .flat_map.with_index { |row, y|
    row.map.with_index { |cell, x| [Vector[x, y], cell.to_i] }
  }
  .to_h
  .tap { |h| h.default = -1 }

def neighbours(grid, position)
  DIRECTIONS
    .map { |dir| position + dir }
    .select { |potential_postition| grid[potential_postition] - grid[position] == 1 }
end

starting_locations = grid.filter { |_k, v| v.zero? }

trails = starting_locations.map do |start_location, _v|
  visited = Set.new
  q = [start_location]
  score = 0
  rating = 0
  until q.empty?
    current_location = q.pop
    if grid[current_location] == 9
      score += 1 if visited.add?(current_location)
      rating += 1
    end
    neighbours(grid, current_location).each { |n| q.push(n) }
  end
  [score, rating]
end

puts 'Part 1'
pp trails.map(&:first).reduce(:+)

puts 'Part 2'
pp trails.map(&:last).reduce(:+)
