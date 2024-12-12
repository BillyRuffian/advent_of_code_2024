require 'matrix'

DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1]].map { |x, y| Vector[x, y] }.freeze
CORNERS = {
  top_left: [Vector[-1, 0], Vector[0, -1]],
  top_right: [Vector[1, 0], Vector[0, -1]],
  bottom_left: [Vector[-1, 0], Vector[0, 1]],
  bottom_right: [Vector[1, 0], Vector[0, 1]]
}

SIDES = 4

class Region
  attr_accessor :id, :cells, :fences, :corners

  def initialize(id, cells = Set.new, fences = 0, corners = 0)
    @id = id
    @cells = cells
    @fences = fences
    @corners = corners
  end

  def price()= @cells.size * @fences
end

def neighbours(grid, position)
  DIRECTIONS
    .map { |dir| position + dir }
    .select { |potential_postition| grid[potential_postition] == grid[position] }
end

def area(grid, position)
  region = Region.new(grid[position])
  q = [position]
  until q.empty?
    current_location = q.pop
    next if region.cells.include?(current_location)

    region.cells.add(current_location)
    n = neighbours(grid, current_location)
    region.fences += SIDES - n.size
    n.each { |n| q.push(n) }
  end
  # finding corners
  region
end

grid = File.new('input.txt')
  .readlines(chomp: true)
  .map(&:chars)
  .flat_map.with_index { |row, y|
    row.map.with_index { |cell, x| [Vector[x, y], cell] }
  }
  .to_h

# regions = Hash.new { |h, k| h[k] = [] }
regions = []

until grid.empty?
  location, _id = grid.first
  region = area(grid, location)
  regions.push(region)
  region.cells.each { |cell| grid.delete(cell) }
end

puts 'Part 1'
pp regions.map(&:price).sum


puts 'Part 2'
pp regions
