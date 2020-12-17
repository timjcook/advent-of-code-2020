class Adapter
  attr_reader :rating

  def initialize(rating:)
    @rating = rating
  end
end

class AdapterGenerator
  def initialize
    @adapter_data = raw_adapter_data
  end

  def generate
    adapter_data.sort.map { |a| Adapter.new(rating: a) }
  end

  private

  attr_reader :adapter_data

  def raw_adapter_data
    File.read('input-data/joltage-adapter-ratings.txt').split("\n").map { |a| a.to_i }
  end
end

class AdapterCombiner
  def initialize(adapters:)
    @adapters = adapters
    @annotated_adapter_chain = create_annotated_adapter_chain
  end

  def num_one_joltage_gaps
    one_joltage_gaps.count
  end

  def num_two_joltage_gaps
    two_joltage_gaps.count
  end

  def num_three_joltage_gaps
    three_joltage_gaps.count
  end

  private

  attr_reader :adapters, :annotated_adapter_chain

  def one_joltage_gaps
    annotated_adapter_chain.filter { |adapter| adapter[:joltage_increase] == 1 }
  end

  def two_joltage_gaps
    annotated_adapter_chain.filter { |adapter| adapter[:joltage_increase] == 2 }
  end

  def three_joltage_gaps
    annotated_adapter_chain.filter { |adapter| adapter[:joltage_increase] == 3 }
  end

  def create_annotated_adapter_chain
    annotated_adapter_chain = adapters.each.with_index.reduce([]) do |acc, (adapter, index)|
      prev_adapter = index > 0 ? adapters[index - 1] : nil

      raise "Invalid adapter" if !prev_adapter.nil? && adapter.rating > (prev_adapter.rating + 3)

      prev_adapter_rating = prev_adapter.nil? ? 0 : prev_adapter.rating
      joltage_increase = adapter.rating - prev_adapter_rating

      acc.push({
        adapter: adapter,
        rating: adapter.rating,
        joltage_increase: joltage_increase
      })
    end

    annotated_adapter_chain.push({
      adapter: nil,
      rating: annotated_adapter_chain.last[:rating] + 3,
      joltage_increase: 3
    })
  end
end

generator = AdapterGenerator.new
adapters = generator.generate

combiner = AdapterCombiner.new(adapters: adapters)

print 'Number of one voltage increases: ', combiner.num_one_joltage_gaps, "\n"
print 'Number of two voltage increases: ', combiner.num_two_joltage_gaps, "\n"
print 'Number of three voltage increases: ', combiner.num_three_joltage_gaps, "\n"

print 'Secret joltage number: ', combiner.num_one_joltage_gaps * combiner.num_three_joltage_gaps, "\n"