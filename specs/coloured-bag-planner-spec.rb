
# frozen_string_literal: true

require_relative '../coloured-bag-planner'

RSpec.describe BagChecker do
  describe 'bags_that_can_contain_subject' do
    let(:subject) { Bag.new(colour: 'shiny gold') }
    let(:blue_bag) { Bag.new(colour: 'bright blue') }
    let(:orange_bag) { Bag.new(colour: 'snazzy orange') }
    let(:purple_bag) { Bag.new(colour: 'deep purple') }
    let(:silver_bag) { Bag.new(colour: 'cool silver') }
    let(:green_bag) { Bag.new(colour: 'great green') }
  
    let(:bags) { [
        subject,
        blue_bag,
        orange_bag,
        purple_bag,
        silver_bag,
        green_bag
      ]
    }

    let(:bag_checker) { described_class.new(bags: bags) }

    before(:each) do
      subject.add_rule(rule: Rule.new(
        colour: green_bag.colour,
        number: 1
      ))

      blue_bag.add_rule(rule: Rule.new(
        colour: subject.colour,
        number: 2
      ))

      orange_bag.add_rule(rule: Rule.new(
        colour: silver_bag.colour,
        number: 1
      ))
      orange_bag.add_rule(rule: Rule.new(
        colour: green_bag.colour,
        number: 3
      ))

      purple_bag.add_rule(rule: Rule.new(
        colour: green_bag.colour,
        number: 2
      ))
      purple_bag.add_rule(rule: Rule.new(
        colour: orange_bag.colour,
        number: 1
      ))

      silver_bag.add_rule(rule: Rule.new(
        colour: blue_bag.colour,
        number: 1
      ))
    end

    specify do
      expect(bag_checker.bags_that_can_contain_subject(subject: subject)).to eq [
        blue_bag,
        orange_bag,
        purple_bag,
        silver_bag
      ]
    end
  end

  describe 'bags_that_are_contained_in_subject' do
    let(:subject) { Bag.new(colour: 'shiny gold') }
    let(:blue_bag) { Bag.new(colour: 'bright blue') }
    let(:orange_bag) { Bag.new(colour: 'snazzy orange') }
    let(:purple_bag) { Bag.new(colour: 'deep purple') }
    let(:silver_bag) { Bag.new(colour: 'cool silver') }
    let(:green_bag) { Bag.new(colour: 'great green') }
  
    let(:bags) { [
        subject,
        blue_bag,
        orange_bag,
        purple_bag,
        silver_bag,
        green_bag
      ]
    }

    let(:bag_checker) { described_class.new(bags: bags) }

    specify do
      subject.add_rule(rule: Rule.new(
        colour: silver_bag.colour,
        number: 2
      ))
      silver_bag.add_rule(rule: Rule.new(
        colour: green_bag.colour,
        number: 2
      ))
      expect(bag_checker.num_bags_that_are_contained_in_subject(subject: subject)).to eq 6
    end

    specify do
      subject.add_rule(rule: Rule.new(
        colour: silver_bag.colour,
        number: 2
      ))
      silver_bag.add_rule(rule: Rule.new(
        colour: purple_bag.colour,
        number: 2
      ))
      purple_bag.add_rule(rule: Rule.new(
        colour: green_bag.colour,
        number: 2
      ))
      expect(bag_checker.num_bags_that_are_contained_in_subject(subject: subject)).to eq 14
    end

    specify do
      subject.add_rule(rule: Rule.new(
        colour: silver_bag.colour,
        number: 2
      ))
      silver_bag.add_rule(rule: Rule.new(
        colour: purple_bag.colour,
        number: 2
      ))
      purple_bag.add_rule(rule: Rule.new(
        colour: orange_bag.colour,
        number: 2
      ))
      orange_bag.add_rule(rule: Rule.new(
        colour: green_bag.colour,
        number: 2
      ))

      expect(bag_checker.num_bags_that_are_contained_in_subject(subject: subject)).to eq 30
    end
  end
end
