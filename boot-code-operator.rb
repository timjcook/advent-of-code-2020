class BootCode
  attr_reader :code, :value

  def initialize(code:, value:)
    @code = code
    @value = value.to_i
  end
end

class BootCodeReader
  def read
    raw_boot_codes.map do |code|
      split_code = code.split(' ')
      BootCode.new(
        code: split_code[0],
        value: split_code[1]
      )
    end
  end

  def raw_boot_codes
    @boot_codes ||= File.read('input-data/boot-code-instructions.txt').split("\n")
  end
end

class BootCodeOperator
  attr_reader :acc

  def initialize(codes:)
    @codes = codes
    @acc = 0
    @position = 0

    @executed_codes = []
  end

  def execute
    while position < codes.count - 1
      code = codes[position]
      return if executed_codes.include?(code)

      executed_codes.push(code)

      execute_code(code: code)
    end
  end

  private

  attr_reader :codes, :position, :executed_codes

  def execute_code(code:)
    case code.code
    when 'acc'
      run_acc(value: code.value)
    when 'jmp'
      run_jmp(value: code.value)
    when 'nop'
      run_nop
    else
      raise 'No code found'
    end
  end

  def run_acc(value:)
    @acc += value
    @position += 1
  end

  def run_jmp(value:)
    @position += value
  end

  def run_nop
    @position += 1
  end
end

reader = BootCodeReader.new
codes = reader.read

operator = BootCodeOperator.new(codes: codes)
operator.execute

print 'Last acc value was: ', operator.acc, "\n"
