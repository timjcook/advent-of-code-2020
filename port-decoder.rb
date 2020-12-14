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
  def self.scan_for_invalid_numbers(stream:)
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
end

reader = StreamReader.new
stream = reader.read
print 'The first invalid number is: ', StreamScanner.scan_for_invalid_numbers(stream: stream).first, "\n"