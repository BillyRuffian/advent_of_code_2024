stones = File
  .read('input.txt')
  .chomp
  .split(' ')
  .map(&:to_i)
  .tally
  .tap { |h| h.default = 0 }

def blink(stones)
  new_stones = Hash.new(0)
  new_stones[1] += stones.delete(0) unless stones[0].zero?

  stones
    .keys
    .map(&:to_s)
    .map(&:chars)
    .filter { |d| d.size.even? }
    .each do |d|
      count = stones.delete(d.join.to_i)
      left = d[0..d.size / 2 - 1].join.to_i
      right = d[d.size / 2..-1].join.to_i
      new_stones[left] += count
      new_stones[right] += count
    end

  stones
    .keys
    .map(&:to_s)
    .map(&:chars)
    .each do |d|
      number = d.join.to_i
      count = stones.delete(number)
      new_stones[number * 2024] += count
    end
  new_stones
end

puts 'Part 1'

25.times do
  stones = blink(stones)
end

puts stones.values.sum

puts 'Part 2'

# already did 25 iterations
50.times do
  stones = blink(stones)
end

puts stones.values.sum
