require 'byebug'
require_relative "board"
require_relative "player"
$settings = {
  0 => { width: 6, height: 6, bombs: 3 },
  1 => { width: 7, height: 7, bombs: 5 },
  2 => { width: 10, height: 8, bombs: 10 },
  3 => { width: 12, height: 10, bombs: 30 },
  4 => { width: 14, height: 12, bombs: 45 }
}

class Game
  def initialize
    @seeded = false
    @player = Player.new
    @level = @player.select_difficulty
    @settings = $settings[@level]
    @board = Board.new(@settings[:width], @settings[:height])
  end

  def play
    take_turn until game_over? || game_won?

    won = game_won?
    @board.reveal_all
    render

    if won
      puts "YOU WON!! :)"
    else
      puts "Game over :("
    end
  end

  def game_won?
    @board.won?
  end

  def game_over?
    @board.over?
  end

  def clear
    system "clear" or system "cls"
  end

  def render
    clear
    @board.render
  end

  def take_turn
    move = @player.get_move(render)
    process_move(move)
  end

  def process_move(move)
    action = move.keys.first
    pos    = move.values.first

    case action
      when :debug
        debugger
      when :select
        highlight(pos)
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
      @board.seed_bombs(pos, @settings[:bombs])
      @seeded = true
    end

    @board.reveal(pos)
  end

  def highlight(pos)
    @board.highlight(pos)
  end
end


if $PROGRAM_NAME == __FILE__
  g = Game.new
  g.play
end
