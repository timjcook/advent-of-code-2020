class ShuttleDataReader
  def read
    earliest_timestamp = raw_shuttle_data[0].to_i
    buses = raw_shuttle_data[1].split(',').filter{ |r| r != "x" }.map do |r|
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

class Bus
  attr_reader :id

  def initialize(id:)
    @id = id
  end

  def frequency
    id
  end

  def to_s
    "Bus ##{id}"
  end
end

class ShuttleTimetable
  def initialize(buses:)
    @buses = buses
  end

  def next_bus(timestamp:)
    bus = nil
    wait_time = 0
    loop do
      buses = buses_for_timestamp(timestamp: timestamp + wait_time)
      if buses.count > 0
        bus = buses.first # we know there will only be one
        break 
      end

      wait_time += 1
    end

    {
      next_bus: bus,
      wait_time: wait_time
    }
  end

  private

  attr_reader :buses

  def buses_for_timestamp(timestamp:)
    buses.filter do |bus|
      timestamp % bus.frequency == 0
    end
  end
end

result = (ShuttleDataReader.new).read

earliest_timestamp = result[:earliest_timestamp]
buses = result[:buses]

timetable = ShuttleTimetable.new(buses: buses)
result = timetable.next_bus(timestamp: earliest_timestamp)
print result[:next_bus], " will be ", result[:wait_time], " minutes away.\n"
print "Magic bus waiting number: #{result[:next_bus].id * result[:wait_time]}\n"
