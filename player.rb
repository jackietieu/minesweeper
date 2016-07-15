require "io/console"

class Player

  def initialize
    @pos = [0,0]
  end

  def select_difficulty
    puts "Select difficulty (0-4):"
    gets.chomp.to_i
  end

  def get_move(board)
    x = board.first.length
    y = board.length

    input = getc
    case input
    when "UP"
      action = :select
      @pos[0] -= 1
      @pos[0] %= y
    when "DOWN"
      action = :select
      @pos[0] += 1
      @pos[0] %= y
    when "LEFT"
      action = :select
      @pos[1] -= 1
      @pos[1] %= x
    when "RIGHT"
      action = :select
      @pos[1] += 1
      @pos[1] %= x
    when "RETURN"
      action = :reveal
    when "F"
      action = :flag
    end

      #require 'byebug'; debugger
    { action => @pos }
  end

  def grab
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def getc
    input = grab

    case input
    when "\e[A"
      input = "UP"
    when "\e[B"
      input = "DOWN"
    when "\e[D"
      input = "LEFT"
    when "\e[C"
      input = "RIGHT"
    when "\r"
      input = "RETURN"
    when "\u0003"
      exit
    end

    input.upcase
  end
end

if $PROGRAM_NAME == __FILE__
  pl = Player.new
  10.times do
    p pl.getc
  end
end
