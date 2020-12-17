EMPTY = 'L'.freeze
OCCUPIED = '#'.freeze
FLOOR = '.'.freeze
INPUT_FILE = 'input'.freeze

class SeatingArea
  private_class_method :new
  def initialize(spots)
    @spots = spots
    @has_changed = true
  end

  def changed?
    @has_changed
  end

  attr_reader :spots

  def self.of(input_file)
    spots = []
    File.open("#{__dir__}/#{input_file}", 'r') do |f|
      f.each_line { |line| spots.push(line.strip) }
    end
    new(spots)
  end

  def apply_rules
    updated_spots = []
    row = 0
    while row < @spots.length
      updated_spots.push('')
      @spots[row].split('').each_with_index { |_, column| updated_spots[row] += apply_rule(row, column) }
      row += 1
    end
    @has_changed = @spots != updated_spots
    @spots = updated_spots
    puts "\n\n"
    puts @spots
  end

  protected

  def apply_rule(row, column)
    spot = @spots[row][column]
    case spot
    when EMPTY
      on_empty(check_adjacent(row, column))
    when OCCUPIED
      on_occupied(check_adjacent(row, column))
    when FLOOR
      spot
    else raise Exception('No such type of spot')
    end
  end

  def check_adjacent(row, column)
    min_row, max_row, min_column, max_column = min_and_max_adjacent_spots(row, column)
    adjacent = { EMPTY => 0, OCCUPIED => 0, FLOOR => 0 }
    (min_row..max_row).each do |current_row|
      (min_column..max_column).each do |current_column|
        adjacent[@spots[current_row][current_column]] += 1 if current_row != row || current_column != column
      end
    end
    adjacent
  end

  def on_empty(adjacent)
    adjacent[OCCUPIED].zero? ? OCCUPIED : EMPTY
  end

  private

  def on_occupied(adjacent)
    adjacent[OCCUPIED] >= 4 ? EMPTY : OCCUPIED
  end

  def min_and_max_adjacent_spots(row, column)
    min_row = row.zero? ? row : row - 1
    max_row = row == @spots.length - 1 ? row : row + 1
    min_column = column.zero? ? column : column - 1
    max_column = column == @spots[row].length - 1 ? column : column + 1
    [min_row, max_row, min_column, max_column]
  end
end

def part1
  seating_area = SeatingArea.of(INPUT_FILE)
  seating_area.apply_rules while seating_area.changed?
  occupied_count = 0
  seating_area.spots.each { |row| occupied_count += row.count('#') }
  puts "El número de sitios ocupados es #{occupied_count}"
end

# part1
