require "io/console"

class Player
  def get_move
    pos = get_pos
    action = get_action

    { action => pos }
  end

  def get_pos
    puts "Enter position"
    gets.chomp.split(',').map(&:to_i)
  end

  def get_action
    puts "[F]lag or [R]eveal?"
    input = gets.chomp.downcase

    if input == 'f'
      return :flag
    else
      return :reveal
    end
  end

  def getc
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
end

if $PROGRAM_NAME == __FILE__
  pl = Player.new
  10.times do
    p pl.getc
  end
end
