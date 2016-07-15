require_relative "tile"

class Board

  def initialize(width = 10, height = 10)
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
    return if self[pos].revealed
    bomb_count = nearby_bombs(pos)
    self[pos].reveal(bomb_count)

    reveal_neighbors(pos) if bomb_count == 0
  end

  def reveal_neighbors(pos)
    neighbors = neighboring_pos(pos)
    neighbors.each do |pos|
      reveal(pos)
    end
  end

  def render
    @grid.each do |row|
      puts row.each { |tile| tile.to_s }.join
    end

    @grid.map do |row|
      row.map do |tile|
        tile.value
      end
    end
  end



  def tile_count
    @width * @height
  end

  def seed_bombs(safe_pos = nil, bomb_count = nil)
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

  def neighboring_pos(pos)
    x, y = pos
    xs = [x - 1, x, x + 1]
    ys = [y - 1, y, y + 1]

    neighbors = xs.product(ys)
    neighbors.reject! { |neighbor| neighbor == pos }
    neighbors.select do |pos|
      x, y = pos
      in_height = (0...@height).to_a.include?(x)
      in_width = (0...@width).to_a.include?(y)

      in_width && in_height
    end
  end

  def neighboring_tiles(pos)
    neighbors = neighboring_pos(pos)
    neighbors.map { |pos| self[pos] }
  end

  def nearby_bombs(pos)
    neighbors = neighboring_tiles(pos)

    bomb_count = 0
    neighbors.each do |neighbor|
      bomb_count += 1 if neighbor.bomb
    end
    bomb_count
  end

  def all_tiles
    @grid.flatten
  end

  def over?
    all_tiles.each do |tile|
      return true if tile.revealed && tile.bomb
    end
    false
  end

  def won?
    all_tiles.each do |tile|
      return false if tile.revealed && tile.bomb
      return false if !tile.bomb && !tile.revealed
    end
    true
  end

  def reveal_all
    (0...@height).each do |x|
      (0...@width).each do |y|
        reveal([x, y]) unless @grid[x][y].revealed
      end
    end
  end

  def highlight(pos)
    all_tiles.each { |tile| tile.deselect }
    self[pos].select
  end
end

if $PROGRAM_NAME == __FILE__
  b = Board.new(10, 10)
  b.seed_bombs([2,2], 4)
  b.render
  b.neighboring_tiles([3,3])
end
