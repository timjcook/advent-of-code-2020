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

processor = SeatBatchProcessor.new

seat_positions = processor.seat_positions
magic_seat_numbers = seat_positions.map { |pos| (pos[:row] * 8) + pos[:column] }

print "Seat codes processed: " + seat_positions.count.to_s + "\n"
print "Highest seat id: " + magic_seat_numbers.max.to_s + "\n"