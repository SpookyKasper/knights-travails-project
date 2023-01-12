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

  def case_exists?(coordinates)
    find_case(coordinates[0], coordinates[1])
  end

  def find_case(x, y)
    @board[x][y]
  end

  def find_coordinates(num)
    coo_row = nil
    coo_col = nil
    @board.each_with_index do |row, index|
      if row.include?(num)
        coo_row = index
        coo_col = row.index(num)
      end
    end
    [coo_row, coo_col]
  end
end

class Knight

  attr_accessor :possible_moves, :board
  # pseudocode for knight moves
  # define the absolute values
  # fead the possible moves with a all the moves that end up in a square on the board

  def initialize(position)
    @board = Board.new(8, 8)
    @position = position
    @abs_moves = [6, 10, 15, 17]
    @knight_movements = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    @possible_moves = possible_moves
  end

  def place_knight()
  end

  def possible_moves
    possible_moves = []
    @knight_movements.each do |knight_move|
      possible_move = @position.map.with_index do |coordinate, index|
        coordinate + knight_move[index]
      end
      possible_moves << possible_move if possible_move.all? {|coordinate| coordinate.between?(0,8)}
    end
    possible_moves
  end
end

knight = Knight.new([0, 2])
knight.board.display
p knight.possible_moves

