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

  def toggle_flag(pos)
    self[pos].toggle_flag
  end

  def reveal(pos)
    self[pos].reveal
  end

  def render
    @grid.each do |row|
      puts row.each { |tile| tile.to_s }.join
    end
  end

  def tile_count
    @width * @height
  end

  def seed_bombs(bomb_count = nil, safe_pos = nil)
    safe_index = (safe_pos.first * @width) + safe_pos.last if safe_pos
    shuffled = []

    loop do
      shuffled = generate_shuffled_bombs(bomb_count)
      break if safe_pos.nil?
      break unless shuffled[safe_index]
    end

    apply_bombs(shuffled)
  end

  def apply_bombs(bomb_array)
    bomb_array.each_with_index do |is_bomb, i|
      tile = @grid[i / @width][i % @width]
      tile.make_bomb if is_bomb
    end
  end

  def generate_shuffled_bombs(bomb_count)
    bomb_count = tile_count / 4 if bomb_count.nil?
    safe_count = tile_count - bomb_count

    bombs = Array.new(bomb_count, true)
    not_bombs = Array.new(safe_count, false)

    (bombs + not_bombs).shuffle
  end

end

if $PROGRAM_NAME == __FILE__
  b = Board.new(4, 4)
  b.seed_bombs(4, [2,2])
  b.render
end
