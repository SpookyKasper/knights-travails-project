# Your task is to build a function knight_moves that shows
# the shortest possible way to get from one square to another
# by outputting all squares the knight will stop on along the way.

# You can think of the board as having 2-dimensional coordinates.
# Your function would therefore look like:

# knight_moves([0,0],[1,2]) == [[0,0],[1,2]]
# knight_moves([0,0],[3,3]) == [[0,0],[1,2],[3,3]]
# knight_moves([3,3],[0,0]) == [[3,3],[1,2],[0,0]]

# Put together a script that creates a game board and a knight.
# Treat all possible moves the knight could make as children in a tree.
# Don’t allow any moves to go off the board.
# Decide which search algorithm is best to use for this case. Hint: one of
# them could be a potentially infinite series.
# Use the chosen search algorithm to find the shortest path between
# the starting square (or node) and the ending square. Output what that full path looks like, e.g.:

#   > knight_moves([3,3],[4,3])
#   => You made it in 3 moves!  Here's your path:
#     [3,3]
#     [4,5]
#     [2,4]
#     [4,3]


# pseudocode for knight_moves
class Board

  attr_accessor :board

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @board = build_board(rows, columns)
  end

  def display
    @board.each {|row| p row}
  end

  def build_board(rows, columns)
    start = 0
    Array.new(rows) do
      Array.new(columns) do |value|
        value = start
        start += 1
      end
    end
  end
end


chess_board = Board.new(8, 8)
chess_board.display

board = chess_board.board

p board[3][1]





def knight_moves(x, y)

end
