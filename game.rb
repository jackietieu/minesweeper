require_relative "board"
require_relative "player"

class Game
  def initialize
    @board = Board.new
    @player = Player.new
  end

  def play
    take_turn until game_over?
  end

  def game_over?
    false
  end

  def clear
    system "clear" or system "cls"
  end

  def render
    clear
    @board.render
  end

  def take_turn
    render
    process_move(@player.get_move)
  end

  def process_move(move)
    action = move.keys.first
    pos    = move.values.first

    
  end
end

if $PROGRAM_NAME == __FILE__
  g = Game.new
  g.play
end
