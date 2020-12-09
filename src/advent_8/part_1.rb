class OperationRunner
  private_class_method :new
  def initialize(operations, context)
    @operations = operations
    @context = context
  end

  def self.of(input_file)
    input = []
    File.open("./#{input_file}", 'r') do |f|
      f.each_line do |line|
        input.push(line)
      end
    end
    context = OperatorContext.new
    operations = input.collect { |input_line| AbstractOperation.of(context, input_line) }
    new(operations, context)
  end

  def run_operations_once
    first_time = true
    while first_time
      operation = @operations[@context.index]
      first_time = operation.times_run.zero?
      operation.run if first_time
    end
  end

  def accumulator
    @context.accumulator
  end
end

class AbstractOperation
  def initialize(context, argument)
    @context = context
    @argument = argument
    @times_run = 0
  end

  def run
    @times_run += 1
    @context.index += 1
  end

  attr_reader :argument
  attr_accessor :times_run

  def self.of(context, input)
    input_parts = input.split(' ')
    operator_class = get_operator_class(input_parts[0])
    operator_class.new(context, input_parts[1].to_i)
  end

  def self.get_operator_class(type)
    case type
    when 'acc'
      AccumulatorOperation
    when 'nop'
      NoOperation
    when 'jmp'
      JumpOperation
    end
  end
end

class AccumulatorOperation < AbstractOperation
  def run
    super
    @context.accumulator += @argument
  end
end

class NoOperation < AbstractOperation
end

class JumpOperation < AbstractOperation
  def run
    super
    @context.index += (@argument - 1)
  end
end

class OperatorContext
  def initialize
    @accumulator = 0
    @index = 0
  end

  attr_accessor :accumulator, :index
end

# example_input = [
#   'nop +0',
#   'acc +1',
#   'jmp +4',
#   'acc +3',
#   'jmp -3',
#   'acc -99',
#   'acc +1',
#   'jmp -4',
#   'acc +6'
# ]

def part1
  operation_runner = OperationRunner.of('input')
  operation_runner.run_operations_once

  puts "Final accumulator value is #{operation_runner.accumulator}"
end

# part1
