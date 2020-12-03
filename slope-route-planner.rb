class Snow
  def snow?
    true
  end

  def tree?
    false
  end
end

class Tree
  def tree?
    true
  end

  def snow?
    false
  end
end

class TerrainMapGenerator

  attr_reader :terrain_map

  def initialize(map_data_path:)
    @map_data_path = map_data_path

    @terrain_map = raw_map_data.map do |row|
      row.map do |tile|
        next Tree.new if tile == '#'

        Snow.new
      end
    end
  end

  private

  attr_reader :map_data_path

  def raw_map_data
    @raw_map_data ||= File.read(map_data_path).split("\n").map { |row| row.split('') }
  end
end

class RoutePlanner
  attr_reader :terrain_map, :position_updater

  def initialize(terrain_map:, position_updater:)
    @terrain_map = terrain_map
    @position_updater = position_updater
    @x = 0
    @y = 0
    @visited_tiles = []

    terrain_map.each.with_index do |row, index|
      next unless index == y

      mark_tile(row)
      move_tiles
    end
  end

  def num_rows_traversed
    visited_tiles.count
  end

  def num_trees_hit
    visited_tiles.filter { |tile| tile.tree? }.count
  end

  private

  attr_reader :visited_tiles
  attr_accessor :x, :y

  def move_tiles
    new_positions = position_updater.update(current_x: x, current_y: y)

    self.x = new_positions[:x]
    self.y = new_positions[:y]
  end

  def mark_tile(row)
    relative_x = x % row.count
    tile = terrain_map[y][relative_x]

    visited_tiles.push(tile)
  end
end

class PositionUpdater
  attr_reader :x_dist, :y_dist

  def initialize(x_dist:, y_dist:)
    @x_dist = x_dist
    @y_dist = y_dist
  end

  def update(current_x:, current_y:)
    {
      x: current_x + x_dist,
      y: current_y + y_dist
    }
  end
end

terrain_map_generator = TerrainMapGenerator.new(map_data_path: 'input-data/slope-terrain.txt')
terrain_map = terrain_map_generator.terrain_map

route_planner_1 = RoutePlanner.new(
  terrain_map: terrain_map,
  position_updater: PositionUpdater.new(x_dist: 1, y_dist: 1)
)
route_planner_2 = RoutePlanner.new(
  terrain_map: terrain_map,
  position_updater: PositionUpdater.new(x_dist: 3, y_dist: 1)
)
route_planner_3 = RoutePlanner.new(
  terrain_map: terrain_map,
  position_updater: PositionUpdater.new(x_dist: 5, y_dist: 1)
)
route_planner_4 = RoutePlanner.new(
  terrain_map: terrain_map,
  position_updater: PositionUpdater.new(x_dist: 7, y_dist: 1)
)
route_planner_5 = RoutePlanner.new(
  terrain_map: terrain_map,
  position_updater: PositionUpdater.new(x_dist: 1, y_dist: 2)
)

print "Number of rows traversed: " + route_planner_1.num_rows_traversed.to_s + "\n"
print "Number of trees hit with route 1: " + route_planner_1.num_trees_hit.to_s + "\n"
print "Number of trees hit with route 2: " + route_planner_2.num_trees_hit.to_s + "\n"
print "Number of trees hit with route 3: " + route_planner_3.num_trees_hit.to_s + "\n"
print "Number of trees hit with route 4: " + route_planner_4.num_trees_hit.to_s + "\n"
print "Number of trees hit with route 5: " + route_planner_5.num_trees_hit.to_s + "\n"
print "\n"
print "Magic sledding number: " + ([
  route_planner_1.num_trees_hit,
  route_planner_2.num_trees_hit,
  route_planner_3.num_trees_hit,
  route_planner_4.num_trees_hit,
  route_planner_5.num_trees_hit
].reduce(:*)).to_s + "\n"
