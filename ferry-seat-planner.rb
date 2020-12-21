class Tile
  def initialize(type:, occupied:)
    @type = type
    @occupied = floor? ? false : occupied
  end

  def seat?
    type == :seat
  end

  def floor?
    type == :floor
  end

  def occupied?
    occupied
  end

  def empty?
    !occupied
  end

  def ==(tile)
    return tile.floor? == floor? && tile.occupied? == occupied?
  end

  def !=(tile)
    return tile.floor? != floor? || tile.occupied? != occupied?
  end

  def to_s
    return '.' if floor?

    (occupied?) ? 'X' : 'L'
  end

  private

  attr_reader :type, :occupied
end

class TileCreator
  def self.create_from_raw
    self.create(seat_data: self.raw_tile_data)
  end
  
  def self.create(seat_data:)
    seat_data.map do |row|
      row.map do |tile|
        next Tile.new(type: :floor, occupied: false) if tile == '.'

        Tile.new(type: :seat, occupied: tile == '#')
      end
    end
  end

  private

  def self.raw_tile_data
    File.read('input-data/ferry-seats.txt').split("\n").map { |row| row.split('') }
  end
end

class TileState
  attr_reader :tiles

  def initialize(tiles: [])
    @tiles = tiles
  end

  def num_occupied_seats
    tiles.reduce(0) do |acc, row|
      acc + row.reduce(0) { |acc, tile| acc + (tile.occupied? ? 1 : 0) }
    end
  end

  def ==(tile_state)
    tile_state.tiles.to_enum.with_index.reduce(true) do |acc, (row, row_index)|
      acc && row.to_enum.with_index.all? { |tile, tile_index| tiles[row_index][tile_index] == tile }
    end
  end
  
  def !=(tile_state)
    tile_state.tiles.to_enum.with_index.reduce(false) do |acc, (row, row_index)|
      acc || row.to_enum.with_index.any? { |tile, tile_index| tiles[row_index][tile_index] != tile }
    end
  end

  def to_s
    tiles.reduce('') do |acc, row|
      acc + row.map { |tile| tile.to_s }.join() + "\n"
    end
  end
end

class SeatingSimulator
  def generate_next_state_for_adjacent(tile_state:)
    new_state = tile_state.tiles.map.with_index do |row, row_index|
      row.map.with_index do |tile, tile_index|
        adjacent_tiles = find_adjacent_tiles(
          current_tile_state: tile_state,
          row_index: row_index,
          tile_index: tile_index
        )
        next_tile_state(
          tile: tile,
          dependent_tiles: adjacent_tiles,
          num_occupied: 4
        )
      end
    end

    TileState.new(tiles: new_state)
  end

  def generate_next_state_for_visible(tile_state:)
    new_state = tile_state.tiles.map.with_index do |row, row_index|
      row.map.with_index do |tile, tile_index|
        visible_seats = find_visible_seats(
          current_tile_state: tile_state,
          row_index: row_index,
          tile_index: tile_index
        )
        next_tile_state(
          tile: tile,
          dependent_tiles: visible_seats,
          num_occupied: 5
        )
      end
    end

    TileState.new(tiles: new_state)
  end

  private

  def next_tile_state(
    tile:,
    dependent_tiles:,
    num_occupied:
  )
    return Tile.new(type: :floor, occupied: false) if tile.floor?

    Tile.new(type: :seat, occupied: occupied_dependent_tiles?(
      tile: tile,
      dependent_tiles: dependent_tiles,
      num_occupied: num_occupied
    ))
  end

  def occupied_dependent_tiles?(
    tile:,
    dependent_tiles:,
    num_occupied:
  )
    return dependent_tiles.all? { |tile| tile.empty? } if tile.empty?

    dependent_tiles.filter { |tile| tile.occupied? }.count < num_occupied
  end

  def find_adjacent_tiles(
    current_tile_state:,
    row_index:,
    tile_index:
  )
    has_prev_row = row_index - 1 >= 0
    has_next_row = row_index + 1 < current_tile_state.tiles.count
    has_prev_tile = tile_index - 1 >= 0
    has_next_tile = tile_index + 1 < current_tile_state.tiles.first.count

    adjacent_tiles = [
      (has_prev_row && has_prev_tile) ? current_tile_state.tiles[row_index - 1][tile_index - 1] : nil,
      (has_prev_row) ? current_tile_state.tiles[row_index - 1][tile_index] : nil,
      (has_prev_row && has_next_tile) ? current_tile_state.tiles[row_index - 1][tile_index + 1] : nil,
      (has_prev_tile) ? current_tile_state.tiles[row_index][tile_index - 1] : nil,
      (has_next_tile) ? current_tile_state.tiles[row_index][tile_index + 1] : nil,
      (has_next_row && has_prev_tile) ? current_tile_state.tiles[row_index + 1][tile_index - 1] : nil,
      (has_next_row) ? current_tile_state.tiles[row_index + 1][tile_index] : nil,
      (has_next_row && has_next_tile) ? current_tile_state.tiles[row_index + 1][tile_index + 1] : nil
    ].compact
  end

  def find_visible_seats(
    current_tile_state:,
    row_index:,
    tile_index:
  )
    options = {
      current_tile_state: current_tile_state,
      starting_x: tile_index,
      starting_y: row_index
    }
    [
      explore_line_of_sight(**options) { |x, y| { x: x - 1, y: y - 1 } },
      explore_line_of_sight(**options) { |x, y| { x: x, y: y - 1 } },
      explore_line_of_sight(**options) { |x, y| { x: x + 1, y: y - 1 } },
      explore_line_of_sight(**options) { |x, y| { x: x - 1, y: y } },
      explore_line_of_sight(**options) { |x, y| { x: x + 1, y: y } },
      explore_line_of_sight(**options) { |x, y| { x: x - 1, y: y + 1 } },
      explore_line_of_sight(**options) { |x, y| { x: x, y: y + 1 } },
      explore_line_of_sight(**options) { |x, y| { x: x + 1, y: y + 1 } }
    ].compact
  end

  def explore_line_of_sight(current_tile_state:, starting_x:, starting_y:)
    visible_seat = nil
    current_tiles = current_tile_state.tiles

    x = starting_x
    y = starting_y

    loop do
      updated_positions = yield(x, y)
      x = updated_positions[:x]
      y = updated_positions[:y]

      break if x < 0 || y < 0 || x >= current_tiles.first.count || y >= current_tiles.count

      visible_tile = current_tiles[y][x]

      if (visible_tile.seat?)
        visible_seat = visible_tile
        break
      end
    end

    visible_seat
  end
end

tile_states_for_adjacent = [TileState.new(tiles: TileCreator.create_from_raw)]

simulator = SeatingSimulator.new
while (tile_states_for_adjacent.count <= 1 || !(tile_states_for_adjacent.last == tile_states_for_adjacent[-2])) do
  tile_states_for_adjacent.push(simulator.generate_next_state_for_adjacent(tile_state: tile_states_for_adjacent.last))
end

print "Num occupied seats at equalibrium: ", tile_states_for_adjacent.last.num_occupied_seats, "\n"

tile_states_for_visible = [TileState.new(tiles: TileCreator.create_from_raw)]

while (tile_states_for_visible.count <= 1 || !(tile_states_for_visible.last == tile_states_for_visible[-2])) do
  tile_states_for_visible.push(simulator.generate_next_state_for_visible(tile_state: tile_states_for_visible.last))
end

print "Num occupied seats at equalibrium: ", tile_states_for_visible.last.num_occupied_seats, "\n"