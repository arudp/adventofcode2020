require_relative('part_1')

class OperationFixer < OperationRunner
  def initialize(*args)
    super(*args)
    @has_updated = false
    @updated_indexes = []
  end

  def fix_operations
    until done?
      puts "Infinito #{@operations[643].inspect}"
      first_time = true
      while !done? && first_time
        operation = @operations[@context.index]
        first_time = operation.times_run.zero?
        operation = maybe_fix(operation)
        operation.run
      end
      reset unless done?
    end
  end

  private

  def done?
    @context.index >= @operations.length
  end

  def reset
    puts "Restarting, changed #{@updated_indexes}\n\n"
    @operations.each { |op| op.times_run = 0 }
    @has_updated = false
    @context.index = 0
    @context.accumulator = 0
    sleep(0.5)
  end

  def maybe_fix(operation)
    operation = fix(operation) if fix?
    operation
  end

  def fix?
    !@has_updated && !(@updated_indexes.include? @context.index)
  end

  def fix(operation)
    operation_type = JumpOperation if operation.instance_of? NoOperation
    operation_type = NoOperation if operation.instance_of? JumpOperation
    puts "OpType #{operation.class} to #{operation_type}" unless operation_type.nil?
    operation = operation_type.new(@context, operation.argument) unless operation_type.nil?
    @has_updated = !operation_type.nil?
    @updated_indexes.push(@context.index) if @has_updated
    operation
  end
end

def part2
  operation_fixer = OperationFixer.of('input')
  operation_fixer.fix_operations

  puts "\nFinal accumulator value is #{operation_fixer.accumulator}"
end

part2
