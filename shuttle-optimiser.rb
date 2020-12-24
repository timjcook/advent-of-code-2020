class ShuttleDataReader
  def read
    earliest_timestamp = raw_shuttle_data[0].to_i
    buses = raw_shuttle_data[1].split(',').map do |r|
      next InactiveBus.new if r == "x"

      Bus.new(id: r.to_i)
    end

    {
      earliest_timestamp: earliest_timestamp,
      buses: buses
    }
  end

  private

  def raw_shuttle_data
    @raw_shuttle_data ||= File.read('input-data/shuttle-timetable.txt').split("\n")
  end
end

class InactiveBus
  def active?
    false
  end

  def to_s
    "x"
  end
end

class Bus
  attr_reader :id

  def initialize(id:)
    @id = id
  end

  def frequency
    id
  end

  def active?
    true
  end

  def to_s
    id.to_s
  end
end

class ShuttleTimetable
  def initialize(buses:)
    @buses = buses
  end

  def next_buses(timestamp:)
    next_buses = []
    wait_time = 0
    loop do
      buses = buses_for_timestamp(timestamp: timestamp + wait_time)
      if buses.count > 0
        next_buses = buses
        break 
      end

      wait_time += 1
    end

    {
      next_buses: next_buses,
      wait_time: wait_time
    }
  end

  def buses_for_timestamp(timestamp:)
    buses.filter do |bus|
      timestamp % bus.frequency == 0
    end
  end

  private

  attr_reader :buses
end

class NaivePatternFinder
  def initialize(buses:)
    @buses = buses
    @pattern = generate_bus_pattern(buses: buses)
    @timetable = ShuttleTimetable.new(buses: buses.filter { |bus| bus.active? })
  end

  def earliest_timestamp_for_pattern
    initial_timestamp = 0
    earliest_timestamp = nil

    first_bus = buses.first # assume the first bus is active

    while earliest_timestamp.nil?
      current_timestamp = initial_timestamp
      current_buses = []

      buses.each do |bus|
        expected_pattern = pattern[0..current_buses.count]
        if bus.active?
          result = timetable.next_buses(timestamp: current_timestamp)
          if result[:next_buses].include?(bus)
            current_buses.push({
              timestamp: current_timestamp,
              bus: result[:next_buses].first
            })
          end
        else
          current_buses.push({
            timestamp: current_timestamp,
            bus: bus
          })
          next
        end

        current_pattern = generate_bus_pattern(buses: current_buses.map { |bus| bus[:bus] })
        break if current_pattern != expected_pattern

        current_timestamp += 1
      end

      if current_buses.count == buses.count
        earliest_timestamp = current_timestamp 
        break
      end

      break if initial_timestamp >= 10000000 # This will go forever if not

      initial_timestamp += first_bus.frequency
    end

    earliest_timestamp
  end

  private

  attr_reader :timetable, :buses, :pattern

  def generate_bus_pattern(buses:)
    buses.map { |bus| bus.to_s }
  end
end

class SmartPatternFinder
  def initialize(buses:)
    @buses = buses
    @active_buses = buses.filter { |bus| bus.active? }
    @timetable = ShuttleTimetable.new(buses: active_buses)
  end

  def earliest_timestamp_for_pattern
    result = active_buses.to_enum.with_index.reduce({
      timestamp: 0,
      interval: buses.first.frequency
    }) do |acc, (bus, index)|
      timestamp_and_interval_for_buses(
        buses: buses_with_limit_active(limit_num: index + 1),
        timestamp: acc[:timestamp],
        interval: acc[:interval]
      )
    end

    result[:timestamp]
  end

  private

  attr_reader :buses, :active_buses, :timetable

  def buses_with_limit_active(limit_num:)
    buses.reduce([]) do |acc, bus|
      acc.push(bus)

      return acc if acc.filter { |bus| bus.active? }.count == limit_num

      acc
    end
  end

  def timestamp_and_interval_for_buses(buses:, timestamp:, interval:)
    loop do
      matches_pattern = buses.to_enum.with_index.reduce(true) do |acc, (bus, index)|
        if bus.active?
          found_buses = timetable.buses_for_timestamp(timestamp: timestamp + index)
          acc = acc && found_buses.include?(bus)
        end

        acc
      end

      break if matches_pattern

      timestamp += interval
    end

    {
      timestamp: timestamp,
      interval: buses
                  .filter { |bus| bus.active? }
                  .reduce(1) { |acc, bus| acc * bus.frequency }
    }
  end
end

result = (ShuttleDataReader.new).read

earliest_timestamp = result[:earliest_timestamp]
buses = result[:buses]

timetable = ShuttleTimetable.new(buses: buses.filter { |bus| bus.active? })
result = timetable.next_buses(timestamp: earliest_timestamp)

print "Bus #", result[:next_buses].first, " will be ", result[:wait_time], " minutes away.\n"
print "Magic bus waiting number: #{result[:next_buses].first.id * result[:wait_time]}\n"

# Left this in for fun, only uncomment if you want to wait forever
#
# finder = NaivePatternFinder.new(buses: buses)
# finder.earliest_timestamp_for_pattern

finder = SmartPatternFinder.new(buses: buses)
print "Earliest timestamp for the contest winning pattern: ", finder.earliest_timestamp_for_pattern, "\n"
