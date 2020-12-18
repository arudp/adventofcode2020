DIRECTIONS = %w[W N E S].freeze
INPUT_FILE = './input'.freeze

class Position
  def initialize
    @current_direction = Direction.new('E')
    @west = 0
    @north = 0
    @east = 0
    @south = 0
  end

  attr_accessor :current_direction, :west, :north, :east, :south

  def to_s
    "{ current_direction: #{@current_direction}, west: #{@west}, north: #{@north}, east: #{@east}, south #{@south} }"
  end
end

class Ship
  def initialize
    @position = Position.new
  end

  def operate(instruction)
    @position = instruction.apply(@position)
  end

  attr_reader :position
end

class Instruction
  def initialize(instruction)
    @value = instruction[1..instruction.length].to_i
    interpret(instruction[0].to_sym).each { |m| extend(m) }
  end

  def apply(position)
    raise NotImplementedError
  end
end

def interpret(instruction_type)
  case instruction_type
  when :R
    [Turn, Right]
  when :L
    [Turn, Left]
  when :F
    [Forward]
  when :W
    [West]
  when :N
    [North]
  when :E
    [East]
  when :S
    [South]
  else
    raise ArgumentError
  end
end

module Turn
  def apply(position)
    movements = (@value % 360) / 90
    movements.times { |_| position = turn(position) }
    position
  end
end

module Right
  private

  def turn(position)
    position.current_direction = position.current_direction.right
    position
  end
end

module Left
  private

  def turn(position)
    position.current_direction = position.current_direction.left
    position
  end
end

module Forward
  def apply(position)
    direction = position.current_direction.direction
    current_value = position.send(direction)
    position.send("#{direction}=", current_value + @value)
    position
  end
end

module West
  def apply(position)
    position.west += @value
    position
  end
end

module North
  def apply(position)
    position.north += @value
    position
  end
end

module East
  def apply(position)
    position.east += @value
    position
  end
end

module South
  def apply(position)
    position.south += @value
    position
  end
end

class Direction
  def initialize(value)
    @value = value
  end

  def right
    move(1)
  end

  def left
    move(-1)
  end

  def direction
    { W: 'west', N: 'north', E: 'east', S: 'south' }[@value.to_sym]
  end

  def to_s
    direction
  end

  private

  def move(movement)
    current_index = DIRECTIONS.index(@value)
    new_direction_value = DIRECTIONS[(current_index + movement) % DIRECTIONS.length]
    Direction.new(new_direction_value)
  end
end

class Navigator
  def initialize(ship, input_file)
    @ship = ship
    @instructions = parse_instructions(input_file)
  end

  def navigate
    @instructions.each do |instruction|
      puts @ship.position
      @ship.operate(instruction)
    end
  end

  def manhattan_distance
    p = @ship.position
    (p.north - p.south).abs + (p.east - p.west).abs
  end

  private

  def parse_instructions(input_file)
    instructions = []
    File.open("#{__dir__}/#{input_file}", 'r') do |f|
      f.each_line { |line| instructions.push(Instruction.new(line)) }
    end
    instructions
  end
end

def part1
  nav = Navigator.new(Ship.new, INPUT_FILE)
  nav.navigate
  puts "Manhattan distance: #{nav.manhattan_distance}"
end

part1
