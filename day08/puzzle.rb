require 'matrix'

grid = Matrix[*File.new('input.txt').readlines.map { |line| line.chomp.chars }]

bounds_x = (0..grid.row_size - 1)
bounds_y = (0..grid.column_size - 1)


frequencies = Hash.new { |h, k| h[k] = [] }
grid.row_vectors.each_with_index.with_object(frequencies) do |(row, y), freq|
  row.each_with_index.with_object(freq) do |(cell, x), freq|
    next if cell == '.'

    freq[cell] << [x, y]
  end
end

puts 'Part 1'

antinodes = Hash.new { |h, k| h[k] = [] }
frequencies.each do |freq, locations|
  locations.combination(2).each do |(x1, y1), (x2, y2)|
    delta_x1 = x1 - x2
    delta_y1 = y1 - y2

    delta_x2 = x2 - x1
    delta_y2 = y2 - y1

    antinode_coords = []
    antinode_coords << [x1 + 2 * delta_x2, y1 + 2 * delta_y2]
    antinode_coords << [x2 + 2 * delta_x1, y2 + 2 * delta_y1]
    antinode_coords.reject! { |x, y| !bounds_x.cover?(x) || !bounds_y.cover?(y) }
    antinodes[freq] += antinode_coords
  end
end

pp antinodes.values.flatten(1).uniq.count

puts 'Part 2'

antinodes = Hash.new { |h, k| h[k] = [] }
frequencies.each do |freq, locations|
  locations.combination(2).each do |(x1, y1), (x2, y2)|
    delta_x1 = x1 - x2
    delta_y1 = y1 - y2

    delta_x2 = x2 - x1
    delta_y2 = y2 - y1

    multiplier = 1
    loop do
      antinode_coords = []
      multiplier += 1
      antinode_coords << [x1 + multiplier * delta_x2, y1 + multiplier * delta_y2]
      antinode_coords << [x2 + multiplier * delta_x1, y2 + multiplier * delta_y1]
      antinode_coords.reject! { |x, y| !bounds_x.cover?(x) || !bounds_y.cover?(y) }
      break if antinode_coords.empty?

      antinodes[freq] += antinode_coords
    end
  end
end

pp antinodes.values.flatten(1).concat(frequencies.values.flatten(1)).uniq.count
