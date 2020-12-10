class SeatBatchProcessor
  def seat_positions
    identifier = SeatIdentifier.new

    seat_codes.map do |code|
      identifier.scan(seat_code: code)
    end
  end

  private

  def seat_codes
    @seat_codes ||= File.read('input-data/seat-codes.txt').split("\n")
  end
end

class SeatIdentifier
  def initialize
    @row_parser = SeatCodeParser.new(lower_marker: "F", upper_marker: "B")
    @column_parser = SeatCodeParser.new(lower_marker: "L", upper_marker: "R")
  end

  def scan(seat_code:)
    @seat_code = seat_code

    {
      row: row,
      column: column
    }
  end

  private

  attr_reader :seat_code, :row_parser, :column_parser

  def row
    row_parser.parse(code: row_code)
  end

  def column
    column_parser.parse(code: column_code)
  end

  def row_code
    seat_code[0..6]
  end

  def column_code
    seat_code[7..-1]
  end
end

class SeatCodeParser
  def initialize(lower_marker:, upper_marker:)
    @lower_marker = lower_marker
    @upper_marker = upper_marker
  end

  def parse(code:)
    find_position(code: code, range: code_range(code: code))
  end

  private

  attr_reader :lower_marker, :upper_marker

  def code_range(code:)
    (0..((2 ** code.length) - 1))
  end

  def find_position(code:, range:)
    return range.begin if range.size == 1

    find_position(
      code: code[1..-1],
      range: (code[0] == lower_marker) ? lower_range(range: range) : upper_range(range: range)
    )
  end

  def lower_range(range:)
    (range.begin..(range.begin + (range.end - range.begin) / 2))
  end

  def upper_range(range:)
    ((range.begin + ((range.end - range.begin) / 2) + 1)..range.end)
  end
end

class SeatFinder
  def find_my_seat(seat_positions:)
    seats_in_rows = sort_into_rows(seat_positions: seat_positions)

    find_empty_seat(seats_in_rows: seats_in_rows)
  end

  private

  SEATS_PER_ROW = 8

  def find_empty_seat(seats_in_rows:)
    seats_in_rows.each do |row, seats|
      if seats.length == SEATS_PER_ROW - 1
        empty_seat = seats.reduce(0) do |acc, filled_seat|
          next acc + 1 if filled_seat.to_i == acc

          acc
        end

        return {
          row: row,
          column: empty_seat.to_s
        }
      end
    end
  end

  def sort_into_rows(seat_positions:)
    seat_positions.sort_by { |pos| pos[:row] }.reduce({}) do |acc, pos|
      if acc[pos[:row].to_s].nil?
        acc[pos[:row].to_s] = [pos[:column]]
      else
        acc[pos[:row].to_s].push(pos[:column])
        acc[pos[:row].to_s] = acc[pos[:row].to_s].sort
      end

      acc
    end
  end
end

class MagicSeatNumberGenerator
  def self.shazam(row, column)
    (row * 8) + column
  end
end

processor = SeatBatchProcessor.new

seat_positions = processor.seat_positions
magic_seat_numbers = seat_positions.map { |pos| MagicSeatNumberGenerator.shazam(pos[:row], pos[:column]) }

print "Seat codes processed: " + seat_positions.count.to_s + "\n"
print "Highest seat id: " + magic_seat_numbers.max.to_s + "\n\n"

seat_finder = SeatFinder.new
seat = seat_finder.find_my_seat(seat_positions: seat_positions)
print "My seat must be: Row " + seat[:row] + " Seat no. " + seat[:column] + "\n"
print "and my seat id must be: " + MagicSeatNumberGenerator.shazam(seat[:row].to_i, seat[:column].to_i).to_s + "\n"
