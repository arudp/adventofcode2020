require_relative('part_1')

TARGET = 85_848_519

class WeaknessFinder < NumberBuffer
  def initialize(*args)
    super(*args)
    @current_index = 0
  end

  def find_target_sum
    while @current_index < @input.length
      sum = 0
      local_index = @current_index - 1
      while local_index < @input.length && sum < TARGET
        local_index += 1
        sum += @input[local_index]
      end

      return sum_min_and_max(@input[@current_index..local_index]) if sum == TARGET

      @current_index += 1
    end
    nil
  end

  def sum_min_and_max(numer_array)
    min = TARGET
    max = -1
    numer_array.each do |n|
      max = n if n > max
      min = n if n < min
    end
    min + max
  end
end

def part2
  finder = WeaknessFinder.of('input', 25)
  weakness = finder.find_target_sum
  puts "The weakness is #{weakness}"
end

part2
