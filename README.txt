[ ][ ][ ][ ][ ][ ]
[ ][F][F] 1  1 [ ]
[ ] 2  3     1 [ ]
[ ][F] 1  2  3 [ ]
[ ][ ][ ][ ] 3 [ ]
[ ][ ][ ][ ][ ][ ]

tile
  bomb?
  flagged?
  reveal?
  selected?

board
  neighbor_tiles(pos)
  tile_number(pos)
  reveal(pos)
  reveal_neighbors(pos)
  current_selection?

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
