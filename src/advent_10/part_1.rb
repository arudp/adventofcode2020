class AdapterHoarder
  private_class_method :new
  def initialize(adapters)
    @adapters = adapters
  end

  def self.of(input_file)
    adapters = []
    max_jolts = 0
    File.open("#{__dir__}/#{input_file}", 'r') do |f|
      f.each_line do |line|
        jolts = line.to_i
        max_jolts = jolts if jolts > max_jolts
        adapters.push(Adapter.new(jolts))
      end
    end

    # Charging outlet
    adapters.push(Adapter.new(0))
    # My device
    adapters.push(Adapter.new(max_jolts + 3))
    new(adapters)
  end

  def get_jolt_differences(adapter_chain)
    differences = { 1 => 0, 2 => 0, 3 => 0 }
    index = 0
    while index < (adapter_chain.length - 1)
      diff = get_difference(adapter_chain[index], adapter_chain[index + 1])
      differences[diff] += 1
      index += 1
    end
    differences
  end

  def get_compatible_chain
    sorted = @adapters.sort_by(&:jolts)
    index = 0
    compatible = [sorted[0]]
    while index < (sorted.length - 1) && sorted[index + 1].can_adapt?(sorted[index])
      compatible.push(sorted[index + 1])
      index += 1
    end
    compatible
  end

  private

  def get_difference(adapter1, adapter2)
    adapter1.jolts > adapter2.jolts ? adapter1.jolts - adapter2.jolts : adapter2.jolts - adapter1.jolts
  end
end

class Adapter
  def initialize(jolts)
    @jolts = jolts
  end

  def can_adapt?(other_adapter)
    other_adapter.jolts.between?(@jolts - 3, @jolts)
  end

  attr_reader :jolts
end

INPUT_FILE = 'input'.freeze

def part1
  hoarder = AdapterHoarder.of(INPUT_FILE)
  chain = hoarder.get_compatible_chain
  diffs = hoarder.get_jolt_differences(chain)

  puts "Las diferencias son: #{diffs}"
  puts "Diferencias[1] * Diferencias[3] = #{diffs[1] * diffs[3]}"
end

# part1
