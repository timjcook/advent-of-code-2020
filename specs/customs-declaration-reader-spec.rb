# frozen_string_literal: true

require_relative '../customs-declaration-reader'

RSpec.describe CustomsDataCalculator do
  let(:customs_data_calculator) { described_class }
  let(:group1) {
    TravellerGroupCustomsData.new(travellers: [
      TravellerCustomsData.new(customs_data: 'abc'),
      TravellerCustomsData.new(customs_data: 'def'),
      TravellerCustomsData.new(customs_data: 'ghi')
    ])
  }
  let(:group2) {
    TravellerGroupCustomsData.new(travellers: [
      TravellerCustomsData.new(customs_data: 'abc'),
      TravellerCustomsData.new(customs_data: 'abc'),
      TravellerCustomsData.new(customs_data: 'abc')
    ])
  }
  let(:group3) {
    TravellerGroupCustomsData.new(travellers: [
      TravellerCustomsData.new(customs_data: 'abc'),
      TravellerCustomsData.new(customs_data: 'abd'),
      TravellerCustomsData.new(customs_data: 'abz')
    ])
  }

  describe 'num_uniq_questions_answered_by_plane' do
    specify do
      expect(customs_data_calculator.num_uniq_questions_answered_by_plane(groups: [
        group1,
        group2,
        group3
      ])).to eq 17
    end
  end

  describe 'num_uniq_questions_answered_by_group' do
    specify do
      expect(customs_data_calculator.num_uniq_questions_answered_by_group(group: group1)).to eq 9
    end

    specify do
      expect(customs_data_calculator.num_uniq_questions_answered_by_group(group: group2)).to eq 3
    end

    specify do
      expect(customs_data_calculator.num_uniq_questions_answered_by_group(group: group3)).to eq 5
    end
  end
end
