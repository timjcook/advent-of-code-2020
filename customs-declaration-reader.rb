class TravellerCustomsData
  attr_reader :customs_data

  def initialize(customs_data:)
    @customs_data = customs_data.split('')
  end
end

class TravellerGroupCustomsData
  attr_reader :travellers

  def initialize(travellers: [])
    @travellers = travellers
  end

  def add_traveller(traveller_data:)
    @travellers.push(traveller_data)
  end
end

class CustomsDataCalculator
  def self.num_uniq_questions_answered_by_plane(groups:)
    groups
      .map { |g| self.num_uniq_questions_answered_by_group(group: g) }
      .reduce(:+)
  end

  def self.num_uniq_questions_answered_by_group(group:)
    group
      .travellers
      .map { |traveller| traveller.customs_data }
      .flatten
      .uniq
      .count
  end

  def self.num_common_questions_answered_by_plane(groups:)
    groups
      .map { |g| self.num_common_questions_answered_by_group(group: g) }
      .reduce(:+)
  end

  def self.num_common_questions_answered_by_group(group:)
    num_travellers = group.travellers.length
    all_answers = group
      .travellers
      .map { |traveller| traveller.customs_data }
      .flatten

    common_answers = all_answers.keep_if do |answer|
      all_answers.clone.keep_if { |d| d == answer }.count == num_travellers
    end

    common_answers.uniq.count
  end
end

class CustomsDeclarationReader
  def read
    customs_data_by_group
  end

  private

  def customs_data_by_group
    raw_customs_data.reduce([TravellerGroupCustomsData.new]) do |acc, row|
      if row.empty?
        acc.push(TravellerGroupCustomsData.new)
      else
        acc.last.add_traveller(traveller_data: TravellerCustomsData.new(customs_data: row))
      end

      acc
    end
  end

  def raw_customs_data
    @customs_data ||= File.read('input-data/customs-declaration-form-data.txt').split("\n")
  end
end

reader = CustomsDeclarationReader.new
groups_on_plane = reader.read

print 'Uniq questions - group score: ' + CustomsDataCalculator.num_uniq_questions_answered_by_plane(groups: groups_on_plane).to_s + "\n"
print 'Common questions - group score: ' + CustomsDataCalculator.num_common_questions_answered_by_plane(groups: groups_on_plane).to_s + "\n"