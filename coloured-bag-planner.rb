class Bag
  attr_reader :colour, :rules

  def initialize(colour:, rules: [])
    @colour = colour
    @rules = rules
  end

  def add_rule(rule:)
    @rules.push(rule)
  end
end

class Rule
  attr_reader :colour

  def initialize(colour:, number:)
    @colour = colour
    @number = number
  end
end

class BagGenerator
  def initialize
    @bags = []
  end

  def run
    create_bags
    assign_rules

    bags
  end

  private

  attr_reader :bags

  def find_or_create_bag(colour:)
    bag = bags.select { |b| b.colour == colour }.first

    return bag unless bag.nil?

    @bags.push(create_bag(colour: colour))
  end

  def create_bags
    classified_data.each { |b| find_or_create_bag(colour: b[:colour]) }
  end

  def assign_rules
    classified_data.each do |bag_data|
      current_bag = bags.select { |b| b.colour == bag_data[:colour] }.first
      rules = bag_data[:rules].map { |rule| create_rule(rule: rule) }

      rules.each do |rule|
        current_bag.add_rule(rule: rule)
      end
    end
  end

  def create_bag(colour:)
    Bag.new(colour: colour)
  end

  def create_rule(rule:)
    split_rule = rule.split(' ')
    Rule.new(
      colour: split_rule[1..2].join(' '),
      number: split_rule[0]
    )
  end

  def classified_data
    @classified_data ||= raw_bag_data.map do |bag_row|
      split_raw_bag_data(bag_row: bag_row)
    end
  end

  def split_raw_bag_data(bag_row:)
    split_data = bag_row.split(' bags contain ')
    {
      colour: split_data[0],
      rules: split_data[1].delete_suffix('.').split(', ')
    }
  end

  def raw_bag_data
    @bag_data ||= File.read('input-data/coloured-bag-restrictions.txt').split("\n")
  end
end

class BagChecker
  def initialize(bags:)
    @bags = bags
  end

  def num_bags_that_can_contain_subject(subject:)
    bags_that_can_contain_subject(subject: subject).count
  end

  def bags_that_can_contain_subject(subject:)
    bags.filter do |bag|
      bag_can_contain_subject?(subject: subject, bag: bag)
    end
  end

  private

  attr_reader :bags

  def find_bag_by_colour(colour:)
    bags.select { |b| b.colour == colour }.first
  end

  def bag_can_contain_subject?(subject:, bag:)
    return false if bag.rules.count == 0

    bag.rules.reduce(false) do |acc, rule|
      return true if rule.colour == subject.colour

      rule_bag = find_bag_by_colour(colour: rule.colour)
      return acc if rule_bag.nil?

      acc || bag_can_contain_subject?(subject: subject, bag: rule_bag)
    end
  end
end

bag_generator = BagGenerator.new
bags = bag_generator.run
my_bag = Bag.new(colour: 'shiny gold')

bag_checker = BagChecker.new(bags: bags)
print "Number of bags that can contain mine: ", bag_checker.num_bags_that_can_contain_subject(subject: my_bag), "\n"
