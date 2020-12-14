class StreamReader
  attr_reader :stream

  def read
    @stream ||= File.read('input-data/data-port-stream.txt').split("\n").map { |s| s.to_i }
  end
end

class Preamble
  def initialize(numbers:)
    @numbers = numbers
  end

  def combination
    numbers.combination(2)
  end

  private

  attr_reader :numbers
end

class NumberValidityChecker
  def initialize(preamble:, number:)
    @preamble = preamble
    @number = number
  end

  def valid?
    preamble.combination.each do |pair|
      return true if pair[0] + pair[1] == number
    end

    false
  end

  private

  attr_reader :preamble, :number
end

class StreamScanner
  def initialize(stream:)
    @stream = stream
  end

  def scan_for_invalid_numbers
    stream[25..].filter.with_index do |number, index|
      preamble = Preamble.new(
        numbers: stream[index..(index + 24)]
      )
      checker = NumberValidityChecker.new(
        preamble: preamble,
        number: number
      )

      !checker.valid?
    end
  end

  def scan_for_encryption_weakness_number
    invalid_number = scan_for_invalid_numbers.first

    stream.each.with_index do |number, index|
      contiguous_set = scan_neighbours_for_encryption_weakness(
        number_index: index,
        invalid_number: invalid_number
      )

      unless contiguous_set.nil?
        sorted_contiguous_set = contiguous_set.sort
        return sorted_contiguous_set.first + sorted_contiguous_set.last
      end
    end

    raise 'Could not find encryption weakness'
  end

  def scan_neighbours_for_encryption_weakness(number_index:, invalid_number:)
    sum = 0
    neighbour_index = 0
    while sum < invalid_number do
      newest_neighbour_index = number_index + neighbour_index
      sum += stream[newest_neighbour_index]

      return stream[number_index..newest_neighbour_index] if sum == invalid_number

      neighbour_index += 1
    end
  end

  private

  attr_reader :stream
end

reader = StreamReader.new
stream = reader.read
scanner = StreamScanner.new(stream: stream)

print 'The first invalid number is: ', scanner.scan_for_invalid_numbers.first, "\n"
print 'The encryption weakness number is: ', scanner.scan_for_encryption_weakness_number, "\n"