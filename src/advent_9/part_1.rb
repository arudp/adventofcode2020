class NumberBuffer
  private_class_method :new
  def initialize(input, buffer_size)
    @lower_index = 0
    @input = input
    @buffer_size = buffer_size
  end

  def self.of(input_file, buffer_size)
    input = []
    File.open("./#{input_file}", 'r') do |f|
      f.each_line do |line|
        input.push(line.to_i)
      end
    end
    new(input, buffer_size)
  end

  def run_until_invalid_number
    @lower_index += 1 while !next_number.nil? && valid_next_number?
  end

  def next_number
    @input[@lower_index + @buffer_size]
  end

  private

  def current_buffer
    @input[@lower_index..@lower_index + @buffer_size - 1]
  end

  def valid_next_number?
    buffer = current_buffer
    buffer.each do |n1|
      buffer.each do |n2|
        return true if n1 != n2 && n1 + n2 == next_number
      end
    end
    false
  end
end

def part1
  buffer = NumberBuffer.of('input', 25)
  buffer.run_until_invalid_number
  puts "Next would have been #{buffer.next_number}"
end

# part1
