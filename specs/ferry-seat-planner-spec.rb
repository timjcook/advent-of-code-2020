# frozen_string_literal: true

require_relative '../ferry-seat-planner'

RSpec.describe SeatingSimulator do
  describe 'generate_next_state' do
    let(:simulator) { SeatingSimulator.new }
    specify do
      tile_state = TileState.new(
        tiles: TileCreator.create(seat_data: [
          'L.LL.LL.LL'.split(''),
          'LLLLLLL.LL'.split(''),
          'L.L.L..L..'.split(''),
          'LLLL.LL.LL'.split(''),
          'L.LL.LL.LL'.split(''),
          'L.LLLLL.LL'.split(''),
          '..L.L.....'.split(''),
          'LLLLLLLLLL'.split(''),
          'L.LLLLLL.L'.split(''),
          'L.LLLLL.LL'.split('')
        ])
      )

      expected_next_tile_state = TileState.new(
        tiles: TileCreator.create(seat_data: [
          '#.##.##.##'.split(''),
          '#######.##'.split(''),
          '#.#.#..#..'.split(''),
          '####.##.##'.split(''),
          '#.##.##.##'.split(''),
          '#.#####.##'.split(''),
          '..#.#.....'.split(''),
          '##########'.split(''),
          '#.######.#'.split(''),
          '#.#####.##'.split('')
        ])
      )

      expect(simulator.generate_next_state(tile_state: tile_state)).to eq expected_next_tile_state
    end

    specify do
      tile_state = TileState.new(
        tiles: TileCreator.create(seat_data: [
          '#.##.##.##'.split(''),
          '#######.##'.split(''),
          '#.#.#..#..'.split(''),
          '####.##.##'.split(''),
          '#.##.##.##'.split(''),
          '#.#####.##'.split(''),
          '..#.#.....'.split(''),
          '##########'.split(''),
          '#.######.#'.split(''),
          '#.#####.##'.split('')
        ])
      )

      expected_next_tile_state = TileState.new(
        tiles: TileCreator.create(seat_data: [
          '#.LL.L#.##'.split(''),
          '#LLLLLL.L#'.split(''),
          'L.L.L..L..'.split(''),
          '#LLL.LL.L#'.split(''),
          '#.LL.LL.LL'.split(''),
          '#.LLLL#.##'.split(''),
          '..L.L.....'.split(''),
          '#LLLLLLLL#'.split(''),
          '#.LLLLLL.L'.split(''),
          '#.#LLLL.##'.split('')
        ])
      )

      expect(simulator.generate_next_state(tile_state: tile_state)).to eq expected_next_tile_state
    end
  end
end

RSpec.describe TileState do
  describe 'num_occupied_seats' do
    let(:tile_state) {
      described_class.new(tiles: [
        [Tile.new(type: :seat, occupied: true), Tile.new(type: :floor, occupied: false), Tile.new(type: :seat, occupied: true)],
        [Tile.new(type: :seat, occupied: false), Tile.new(type: :floor, occupied: false), Tile.new(type: :floor, occupied: false)],
        [Tile.new(type: :seat, occupied: true), Tile.new(type: :seat, occupied: false), Tile.new(type: :seat, occupied: true)]
      ])
    }

    specify do
      expect(tile_state.num_occupied_seats).to eq 4
    end
  end
end