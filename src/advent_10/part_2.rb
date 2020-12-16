require_relative './part_1'

class AdapterPermutator < AdapterHoarder
  def get_valid_permutations(chain)
    nodes = explore_paths(chain)
    nodes[0].get_paths
  end

  def explore_paths(chain)
    nodes = chain.collect { |adapter| Node.new(adapter) }
    index = 0
    while index < nodes.length - 1
      inner_index = index
      node = nodes[index]
      inner_index += 1 while inner_index < (@adapters.length - 1) && node.add_if_valid(nodes[inner_index + 1])
      index += 1
    end
    nodes
  end
end

class Node
  def initialize(adapter)
    @adapter = adapter
    @targets = []
  end

  def add_target(node)
    @targets.push(node)
  end

  def add_if_valid(node)
    add_target(node) if node.adapter.can_adapt?(@adapter)
  end

  def get_paths
    # 5| 6, 7, 8
    # 5| 6, 8
    # 5| 7, 8
    # 5| 8
    paths = [] # @targets.collect { |t| [ t.adapter.jolts ] }
    # [ [6], [7], [8] ]
    @targets.each do |t|
      target_paths = t.get_paths # [ [7, 8], [8] ]
      if target_paths.empty?
        paths.push([t.adapter.jolts])
      else
        target_paths.each { |tp| paths.push([t.adapter.jolts].concat(tp)) }
      end
    end
    paths
  end

  attr_reader :target_nodes, :adapter
end

def part2
  permutator = AdapterPermutator.of(INPUT_FILE)
  chain = permutator.get_compatible_chain
  puts permutator.get_valid_permutations(chain).length
end

part2
