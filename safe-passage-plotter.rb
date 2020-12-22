class Instruction

  attr_reader :type, :value

  def initialize(instruction:)
    @type = derive_type(instruction: instruction)
    @value = derive_value(instruction: instruction)
  end

  private

  def derive_type(instruction:)
    case instruction[0]
    when "N"
      return :north
    when "S"
      return :south
    when "E"
      return :east
    when "W"
      return :west
    when "L"
      return :left
    when "R"
      return :right
    when "F"
      return :forward
    else
      raise "invalid instruction type"
    end
  end

  def derive_value(instruction:)
    instruction[1..].to_i
  end
end

class InstructionReader
  def run
    raw_instructions.map{ |instruction| Instruction.new(instruction: instruction) }
  end

  def raw_instructions
    @instructions ||= File.read('input-data/safe-passage-instructions.txt').split("\n")
  end
end

class Ferry
  def initialize
    @x = 0
    @y = 0
    @direction = 0
  end

  def current_position
    {
      x: x,
      pretty_x: pretty_x,
      y: y,
      pretty_y: pretty_y,
      direction: direction,
      pretty_direction: calc_current_direction,
      manhatten: calc_manhatten_distance
    }
  end

  def perform_instruction(instruction:)
    case instruction.type
    when :north
      @y += instruction.value
    when :south
      @y -= instruction.value
    when :east
      @x += instruction.value
    when :west
      @x -= instruction.value
    when :left
      @direction = calc_direction(value: instruction.value * -1)
    when :right
      @direction = calc_direction(value: instruction.value)
    when :forward
      perform_instruction(instruction: Instruction.new(instruction: calc_current_direction + instruction.value.to_s))
    else
      raise "Invalid instruction type"
    end
  end

  private

  attr_reader :x, :y, :direction

  def pretty_x
    return "#{x} East" if x > 0
    return "#{x * -1} West" if x < 0

    return "No movement east or west"
  end

  def pretty_y
    return "#{y} North" if y > 0
    return "#{y * -1} South" if y < 0

    return "No movement north or south"
  end

  def calc_direction(value:)
    new_direction = direction + value

    return new_direction - 360 if new_direction >= 360
    return new_direction + 360 if new_direction < 0

    new_direction
  end

  def calc_manhatten_distance
    x.abs + y.abs
  end

  def calc_current_direction
    case direction
    when 0
      "E"
    when 90
      "S"
    when 180
      "W"
    when 270
      "N"
    else
      raise "Invalid direction value"
    end
  end
end

reader = InstructionReader.new
instructions = reader.run

ferry = Ferry.new

instructions.each do |instruction|
  ferry.perform_instruction(instruction: instruction)
end

current_position = ferry.current_position
print "We are currently sitting #{current_position[:pretty_x]} and #{current_position[:pretty_y]} of where we started, facing #{current_position[:pretty_direction]}.\n"
print "Our manhatten distance is #{current_position[:manhatten]}.\n"