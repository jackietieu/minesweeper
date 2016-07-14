require_relative "board"
require_relative "player"

class Game
  def initialize
    @seeded = false
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

    case action
      when :select
        # impliment with getc
      when :flag
        flag(pos)
      when :reveal
        reveal(pos)
    end
  end

  def flag(pos)
    @board.toggle_flag(pos)
  end

  def reveal(pos)
    unless @seeded
      @board.seed_bombs(pos)
      @seeded = true
    end

    @board.reveal(pos)
  end
end


if $PROGRAM_NAME == __FILE__
  g = Game.new
  g.play
end
