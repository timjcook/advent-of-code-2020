class BootCode
  attr_reader :value
  attr_accessor :code

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
    while position < codes.count
      code = codes[position]
      return if executed_codes.include?(code)

      executed_codes.push(code)

      execute_code(code: code)
    end
  end

  def ran_to_completion?
    position == codes.count
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

class BootCodeFixer
  attr_reader :codes, :current_operator

  def initialize(codes:)
    @codes = codes
    @position = 0
    @current_operator = nil
  end

  def fix_corruption
    @current_operator = BootCodeOperator.new(codes:codes)
    while position < codes.count
      code = codes[position]

      if code.code == 'jmp' || code.code == 'nop'
        @current_operator = BootCodeOperator.new(
          codes: fixed_codes_possibility(
            code: code,
            position: position
          )
        )
        @current_operator.execute
        return if @current_operator.ran_to_completion?
      end

      @position += 1
    end

    @current_operator = nil
  end

  private

  attr_reader :position

  def fixed_codes_possibility(code:, position:)
    possible_codes = codes.clone

    if (code.code == 'jmp')
      possible_codes[position] = BootCode.new(
        code: 'nop',
        value: code.value
      )
    else
      possible_codes[position] = BootCode.new(
        code: 'jmp',
        value: code.value
      )
    end

    possible_codes
  end
end

reader = BootCodeReader.new
codes = reader.read

operator = BootCodeOperator.new(codes: codes)
operator.execute

print 'Infinite loop - Last acc value was: ', operator.acc, "\n"

fixer = BootCodeFixer.new(codes: codes)
fixer.fix_corruption

unless fixer.current_operator.nil?
  print 'Infinite loop fix - Last acc value was: ', fixer.current_operator.acc, "\n"
else
  print "Infinite loop fix - No fix found :(\n"
end
