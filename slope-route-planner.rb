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
  attr_reader :terrain_map

  def initialize(terrain_map)
    @terrain_map = terrain_map
    @x = 0
    @y = 0
    @visited_tiles = []

    terrain_map.each do |row|
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
    self.x = x + 3
    self.y = y + 1
  end

  def mark_tile(row)
    relative_x = x % row.count
    tile = terrain_map[y][relative_x]

    visited_tiles.push(tile)
  end
end

terrain_map_generator = TerrainMapGenerator.new(map_data_path: 'input-data/slope-terrain.txt')
terrain_map = terrain_map_generator.terrain_map

route_planner = RoutePlanner.new(terrain_map)

print "Number of rows traversed: " + route_planner.num_rows_traversed.to_s + "\n"
print "Number of trees hit: " + route_planner.num_trees_hit.to_s + "\n"
