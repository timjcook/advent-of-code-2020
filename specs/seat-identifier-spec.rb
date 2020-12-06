# frozen_string_literal: true

require_relative '../seat-identifier'

RSpec.describe SeatIdentifier do
  let(:seat_identifier) { described_class.new }

  specify do
    expect(seat_identifier.scan(seat_id: 'FBFBBFFRLR')[:row]).to eq 44
    expect(seat_identifier.scan(seat_id: 'FBFBBFFRLR')[:column]).to eq 5
  end

  specify do
    expect(seat_identifier.scan(seat_id: 'BFFFBBFRRR')[:row]).to eq 70
    expect(seat_identifier.scan(seat_id: 'BFFFBBFRRR')[:column]).to eq 7
  end

  specify do
    expect(seat_identifier.scan(seat_id: 'FFFBBBFRRR')[:row]).to eq 14
    expect(seat_identifier.scan(seat_id: 'FFFBBBFRRR')[:column]).to eq 7
  end

  specify do
    expect(seat_identifier.scan(seat_id: 'BBFFBBFRLL')[:row]).to eq 102
    expect(seat_identifier.scan(seat_id: 'BBFFBBFRLL')[:column]).to eq 4
  end
end
