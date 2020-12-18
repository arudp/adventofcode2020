require_relative './part_1'

BACKWARDS = 'BACKWARDS'.freeze
FORWARD = 'FORWARD'.freeze

PAIRS = [
  { row_direction: nil, column_direction: BACKWARDS }, # left
  { row_direction: BACKWARDS, column_direction: BACKWARDS }, # upleft
  { row_direction: BACKWARDS, column_direction: nil }, # up
  { row_direction: BACKWARDS, column_direction: FORWARD }, # upright
  { row_direction: nil, column_direction: FORWARD }, # right
  { row_direction: FORWARD, column_direction: FORWARD }, # downright
  { row_direction: FORWARD, column_direction: nil }, # down
  { row_direction: FORWARD, column_direction: BACKWARDS } # downleft
].freeze

class Movement
  def initialize(area, row_direction: nil, column_direction: nil)
    @row_movement = ->(r) { r + movement_addition(row_direction) }
    @column_movement = ->(c) { c + movement_addition(column_direction) }
    @row_condition = calculate_stop_condition(row_direction, area)
    @column_condition = ->(r, c) { calculate_stop_condition(column_direction, area[r]).call(c) }
  end

  def next(row, column)
    [@row_movement.call(row), @column_movement.call(column)]
  end

  def stop?(row, column)
    @row_condition.call(row) || @column_condition.call(row, column)
  end

  private

  def movement_addition(direction)
    case direction
    when BACKWARDS
      -1
    when FORWARD
      1
    else
      0
    end
  end

  def calculate_stop_condition(direction, limits)
    case direction
    when BACKWARDS
      ->(e) { e.negative? }
    when FORWARD
      ->(e) { e >= limits.length }
    else
      ->(_) { false }
    end
  end
end

class VisibleSeatingArea < SeatingArea
  def check_adjacent(row, column)
    adjacent = { EMPTY => 0, OCCUPIED => 0, FLOOR => 0 }
    PAIRS.each do |pair|
      movement = Movement.new(@spots, row_direction: pair[:row_direction], column_direction: pair[:column_direction])
      adjacent[get_first_seat(row, column, movement)] += 1
    end
    adjacent
  end

  def on_occupied(adjacent)
    adjacent[OCCUPIED] >= 5 ? EMPTY : OCCUPIED
  end

  private

  def get_first_seat(row, column, movement)
    found = FLOOR
    current_row, current_column = movement.next(row, column)
    until found != FLOOR || movement.stop?(current_row, current_column)
      found = @spots[current_row][current_column]
      current_row, current_column = movement.next(current_row, current_column)
    end
    found
  end
end

def part2
  seating_area = VisibleSeatingArea.of(INPUT_FILE)
  seating_area.apply_rules while seating_area.changed?
  occupied_count = 0
  seating_area.spots.each { |row| occupied_count += row.count('#') }
  puts "El número de sitios ocupados es #{occupied_count}"
end

part2
