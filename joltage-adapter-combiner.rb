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

  def num_possible_combinations
    combination_groups_for_adapters
      .map { |group| group.combination_score }
      .reduce(:*)
  end

  private

  attr_reader :adapters, :annotated_adapter_chain

  def combination_groups_for_adapters
    annotated_adapter_chain.each.with_index.reduce([]) do |acc, (adapter, index)|
      if acc.count == 0 || adapter[:joltage_increase] > 1
        acc.push(AdapterGroup.new(adapters: [adapter]))
      else
        group = acc.last
        group.add_adapter(adapter: adapter)
      end

      acc
    end
  end

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

    annotated_adapter_chain.prepend({
      adapter: nil,
      rating: 0,
      joltage_increase: 0
    })
    annotated_adapter_chain.push({
      adapter: nil,
      rating: annotated_adapter_chain.last[:rating] + 3,
      joltage_increase: 3
    })
  end
end

class AdapterGroup
  def initialize(adapters:)
    @adapters = adapters
  end

  def add_adapter(adapter:)
    @adapters.push(adapter)
  end

  def combination_score
    CombinationScorer.combination_score(num_members: adapters.count)
  end

  private

  attr_reader :adapters
end

class CombinationScorer
  def self.combination_score(num_members:)
    raise "num_members must be 1 or more" if num_members == 0

    valid_combinations = self.possible_combinations(num_members: num_members)
      .filter { |combo| self.valid_combination(combination: combo) }

    valid_combinations.count
  end

  private

  def self.possible_combinations(num_members:)
    members = [*0..((2 ** num_members) - 1)]
    members.map do |m|
      m.to_s(2).rjust(num_members, "0").split("")
    end
  end

  def self.valid_combination(combination:)
    return false if combination.first != "1" || combination.last != "1"

    combination.each.with_index.reduce(true) do |acc, (bit, index)|
      next acc && true if bit == "1" || index <= 2

      acc && [
        combination[index - 1] == "1",
        combination[index - 2] == "1"
      ].any?
    end
  end
end

generator = AdapterGenerator.new
adapters = generator.generate

combiner = AdapterCombiner.new(adapters: adapters)

print 'Number of one voltage increases: ', combiner.num_one_joltage_gaps, "\n"
print 'Number of two voltage increases: ', combiner.num_two_joltage_gaps, "\n"
print 'Number of three voltage increases: ', combiner.num_three_joltage_gaps, "\n"

print 'Secret joltage number: ', combiner.num_one_joltage_gaps * combiner.num_three_joltage_gaps, "\n"

print 'Num possible combinations: ', combiner.num_possible_combinations, "\n"
