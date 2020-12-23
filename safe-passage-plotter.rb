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

class FerryMovementInstructionActioner
  def perform(instruction:, position:, waypoint_position:, direction:)
    case instruction.type
    when :north
      position[:y] += instruction.value
    when :south
      position[:y] -= instruction.value
    when :east
      position[:x] += instruction.value
    when :west
      position[:x] -= instruction.value
    when :left
      direction = calc_direction(direction: direction, value: instruction.value * -1)
    when :right
      direction = calc_direction(direction: direction, value: instruction.value)
    when :forward
      return perform(
        instruction: Instruction.new(instruction: direction_name(direction: direction) + instruction.value.to_s),
        position: position,
        waypoint_position: nil,
        direction: direction
      )
    else
      raise "Invalid instruction type"
    end

    {
      position: position,
      direction: direction
    }
  end

  private

  def calc_direction(direction:, value:)
    new_direction = direction + value

    return new_direction - 360 if new_direction >= 360
    return new_direction + 360 if new_direction < 0

    new_direction
  end

  def direction_name(direction:)
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

class FerryWaypointInstructionActioner
  def perform(instruction:, position:, waypoint_position:, direction:)
    case instruction.type
    when :north
      waypoint_position[:y] += instruction.value
    when :south
      waypoint_position[:y] -= instruction.value
    when :east
      waypoint_position[:x] += instruction.value
    when :west
      waypoint_position[:x] -= instruction.value
    when :left
      new_direction = update_waypoint_direction(waypoint_position: waypoint_position, rotation_direction: :anticlockwise, value: instruction.value)

      waypoint_position[:x] = new_direction[:x]
      waypoint_position[:y] = new_direction[:y]
    when :right
      new_direction = update_waypoint_direction(waypoint_position: waypoint_position, rotation_direction: :clockwise, value: instruction.value)

      waypoint_position[:x] = new_direction[:x]
      waypoint_position[:y] = new_direction[:y]
    when :forward
      new_position = update_position_by_waypoint(position: position, waypoint_position: waypoint_position, value: instruction.value)

      position[:x] = new_position[:x]
      position[:y] = new_position[:y]
    else
      raise "Invalid instruction type"
    end

    {
      position: position,
      waypoint_position: waypoint_position
    }
  end

  private

  def update_position_by_waypoint(position:, waypoint_position:, value:)
    {
      x: position[:x] + (waypoint_position[:x] * value),
      y: position[:y] + (waypoint_position[:y] * value)
    }
  end

  def update_waypoint_direction(waypoint_position:, rotation_direction:, value:)
    num_turns = value / 90

    current_waypoint_position = {
      x: waypoint_position[:x],
      y: waypoint_position[:y]
    }

    [*1..num_turns].each do
      current_x = current_waypoint_position[:x]
      current_y = current_waypoint_position[:y]

      if rotation_direction == :clockwise
        current_waypoint_position[:x] = current_y
        current_waypoint_position[:y] = current_x * -1
      else
        current_waypoint_position[:x] = current_y * -1
        current_waypoint_position[:y] = current_x
      end
    end

    current_waypoint_position
  end
end


class Ferry
  def initialize(instruction_actioner:)
    @instruction_actioner = instruction_actioner
    @position = {
      x: 0,
      y: 0
    }
    @direction = 0
    @waypoint_position = {
      x: 10,
      y: 1
    }
  end

  def current_position
    {
      x: position[:x],
      pretty_x: pretty_x,
      y: position[:y],
      pretty_y: pretty_y,
      manhatten: manhatten_distance
    }
  end

  def perform_instruction(instruction:)
    result = instruction_actioner.perform(
      instruction: instruction,
      position: {
        x: position[:x],
        y: position[:y]
      },
      waypoint_position: waypoint_position,
      direction: direction
    )
    @position = result[:position]
    @waypoint_position = result[:waypoint_position]
    @direction = result[:direction]
  end

  private

  attr_reader :instruction_actioner, :position, :direction, :waypoint_position

  def pretty_x
    return "#{position[:x]} East" if position[:x] > 0
    return "#{position[:x] * -1} West" if position[:x] < 0

    return "No movement east or west"
  end

  def pretty_y
    return "#{position[:y]} North" if position[:y] > 0
    return "#{position[:y] * -1} South" if position[:y] < 0

    return "No movement north or south"
  end

  def manhatten_distance
    position[:x].abs + position[:y].abs
  end
end

reader = InstructionReader.new
instructions = reader.run

ferry = Ferry.new(
  instruction_actioner: FerryMovementInstructionActioner.new
)
instructions.each do |instruction|
  ferry.perform_instruction(instruction: instruction)
end

current_position = ferry.current_position
print "Moving the ferry according to instructions:\n"
print "We are currently sitting #{current_position[:pretty_x]} and #{current_position[:pretty_y]} of where we started.\n"
print "Our manhatten distance is #{current_position[:manhatten]}.\n\n"

waypoint_ferry = Ferry.new(
  instruction_actioner: FerryWaypointInstructionActioner.new
)
instructions.each do |instruction|
  waypoint_ferry.perform_instruction(instruction: instruction)
end

current_position = waypoint_ferry.current_position
print "Moving the ferry according to waypoint position:\n"
print "We are currently sitting #{current_position[:pretty_x]} and #{current_position[:pretty_y]} of where we started.\n"
print "Our manhatten distance is #{current_position[:manhatten]}.\n"