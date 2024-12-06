require 'matrix'

DIRECTIONS = { '^' => [-1, 0], 'v' => [1, 0], '<' => [0, -1], '>' => [0, 1] }.freeze
TURNS = { '^' => '>', '>' => 'v', 'v' => '<', '<' => '^' }.freeze

grid = Matrix[*File.readlines('input.txt', chomp: true).map(&:chars)]
  .each_with_index
  .with_object({}) { |(value, row, col), memo| memo[[row, col]] = value }

def current_position(grid)
  grid.find { |pos, char| DIRECTIONS.keys.include?(char) }.first
end

def walk_path(grid, position, direction = '^', obstruction = nil, visited = Set.new)
  # Penny drop! for part 2 -- I know I'm in a loop *if* I've visited this
  # position before and I am facing the *same direction!!*
  return false if visited.include?([position, direction])

  visited << [position, direction]
  facing = DIRECTIONS[direction]
  next_position = position.zip(facing).map(&:sum)

  while grid[next_position] == '#' || next_position == obstruction
    direction = TURNS[direction]
    facing = DIRECTIONS[direction]
    next_position = position.zip(facing).map(&:sum)
  end

  return visited.map(&:first).uniq unless grid[next_position]

  walk_path(grid, next_position, direction, obstruction, visited)
end

visited = walk_path(grid, current_position(grid))

puts 'Part 1'
pp visited.size

puts 'Part 2'
# we have all the positions we visited, so we can test if
# an obstacle in any of those positions creates a loop
loop_posibilities = visited.count do |obstruction|
  walk_path(grid, current_position(grid), '^', obstruction) == false
end

pp loop_posibilities
