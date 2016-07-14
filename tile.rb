require 'colorize'

class Tile
  attr_writer :nearby_bombs
  attr_reader :bomb, :revealed

  def initialize
    @bomb, @flagged, @revealed, @selected = false
    @nearby_bombs = 0
  end

  def make_bomb
    @bomb = true
  end

  def reveal(bombs)
    @nearby_bombs = bombs
    @revealed = true
    @flagged = false
  end

  def toggle_flag
    return if @revealed
    @flagged = !@flagged
  end

  def flag
    return if @revealed
    @flagged = true
  end

  def unflag
    @flagged = false
  end

  def select
    @selected = true
  end

  def deselect
    @selected = false
  end

  def color
    @selected ? :blue : :white
  end

  def marker
    # return "[*]" if @bomb
    return "[F]" if @flagged
    return "[ ]" if !@revealed
    return " * " if @bomb
    return "   " if @nearby_bombs == 0
    return " #{@nearby_bombs} "
  end

  def to_s
    marker.colorize(color)
  end

  # private
  # attr_reader :bomb, :flagged, :revealed, :selected
end

if $PROGRAM_NAME == __FILE__
  t = Tile.new
  t.flag
  t.nearby_bombs = 3
  # t.select
  # t.reveal

  puts t.to_s
end
