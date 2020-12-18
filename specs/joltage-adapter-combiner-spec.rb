# frozen_string_literal: true

require_relative '../joltage-adapter-combiner'

RSpec.describe AdapterCombiner do

  describe 'num_possible_combinations' do
    specify do
      adapters = [
        Adapter.new(rating: 1),
        Adapter.new(rating: 4),
        Adapter.new(rating: 5),
        Adapter.new(rating: 6),
        Adapter.new(rating: 7),
        Adapter.new(rating: 10),
        Adapter.new(rating: 11),
        Adapter.new(rating: 12),
        Adapter.new(rating: 15),
        Adapter.new(rating: 16),
        Adapter.new(rating: 19)
      ]
      adapter_combiner = described_class.new(adapters: adapters)
      expect(adapter_combiner.num_possible_combinations).to eq 8
    end

    specify do
      adapters = [
        Adapter.new(rating: 1),
        Adapter.new(rating: 2),
        Adapter.new(rating: 3),
        Adapter.new(rating: 4),
        Adapter.new(rating: 7),
        Adapter.new(rating: 8),
        Adapter.new(rating: 9),
        Adapter.new(rating: 10),
        Adapter.new(rating: 11),
        Adapter.new(rating: 14),
        Adapter.new(rating: 17),
        Adapter.new(rating: 18),
        Adapter.new(rating: 19),
        Adapter.new(rating: 20),
        Adapter.new(rating: 23),
        Adapter.new(rating: 24),
        Adapter.new(rating: 25),
        Adapter.new(rating: 28),
        Adapter.new(rating: 31),
        Adapter.new(rating: 32),
        Adapter.new(rating: 33),
        Adapter.new(rating: 34),
        Adapter.new(rating: 35),
        Adapter.new(rating: 38),
        Adapter.new(rating: 39),
        Adapter.new(rating: 42),
        Adapter.new(rating: 45),
        Adapter.new(rating: 46),
        Adapter.new(rating: 47),
        Adapter.new(rating: 48),
        Adapter.new(rating: 49)
      ]
      adapter_combiner = described_class.new(adapters: adapters)
      expect(adapter_combiner.num_possible_combinations).to eq 19208
    end
  end
end

RSpec.describe CombinationScorer do

  describe 'combination_score' do
    let(:combination_scorer) { described_class }

    specify do
      expect(combination_scorer.combination_score(num_members: 1)).to eq 1
    end
    specify do
      expect(combination_scorer.combination_score(num_members: 2)).to eq 1
    end
    specify do
      expect(combination_scorer.combination_score(num_members: 3)).to eq 2
    end
    specify do
      expect(combination_scorer.combination_score(num_members: 4)).to eq 4
    end
    specify do
      expect(combination_scorer.combination_score(num_members: 5)).to eq 7
    end
  end
end
