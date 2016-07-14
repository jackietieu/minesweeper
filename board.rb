require_relative "tile"

class Board

  def initialize(width = 4, height = 4)
    @width = width
    @height = height
    @grid = empty_grid
  end

  def empty_grid
    Array.new(@height) do
      Array.new(@width) { Tile.new }
    end
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def render
    @grid.each do |row|
      puts row.each { |tile| tile.to_s }.join
    end
  end

  def tile_count
    @width * @height
  end

  def seed_bombs(bomb_count = tile_count / 4)
    safe_count = tile_count - bomb_count

    bombs = Array.new(bomb_count, true)
    not_bombs = Array.new(safe_count, false)

    shuffled = (bombs + not_bombs).shuffle
    shuffled.each_with_index do |is_bomb, i|
      tile = @grid[i / @width][i % @width]
      tile.make_bomb if is_bomb
    end
  end


end

if $PROGRAM_NAME == __FILE__
  b = Board.new(4, 4)
  b.seed_bombs
  b.render
end
