map = File.read('input.txt').chomp.chars.map(&:to_i)

block_id_generator = (0...).to_enum

disk = map.flat_map.with_index do |block, idx|
  if idx % 2 == 0
    [block_id_generator.next] * block
  else
    [nil] * block
  end
end

disk_1 = disk.dup
disk_2 = disk.dup

def checksum(disk)
  disk
    .map
    .with_index { |block, idx| block.nil? ? 0 : block * idx }
    .sum
end


# oh boy, this is inefficient

puts 'Part 1'
free = disk_1.filter_map.with_index { |block, idx| idx if block.nil? }

# until free.empty?
#   block_to_move = disk_1.rindex { |block| block != nil }
#   free_block = free.shift
#   disk_1[free_block] = disk_1[block_to_move]
#   disk_1[block_to_move] = nil
# end


pp checksum(disk_1)

# oh god, this is even more inefficient

puts 'Part 2'

free = disk_2
  .filter_map
  .with_index { |block, idx| idx if block.nil? }
  .chunk_while { |left, right| left + 1 == right }
  .to_a

(0..disk_2.reject(&:nil?).max)
  .to_a
  .reverse
  .each do |block_id|
    file_length = disk_2.count(block_id)
    file_start = disk_2.index(block_id)
    free_slot = free.find { |slot| slot.length >= file_length }
    next unless free_slot
    next if file_start < free_slot.first

    free_slot.shift(file_length).each do |slot|
      disk_2[slot] = block_id
    end
    # oh my eyes
    free << (file_start..(file_start+file_length-1)).to_a
    free = free.reject(&:empty?).sort_by(&:first)
    disk_2[file_start, file_length] = [nil] * file_length
  end

pp checksum(disk_2)
