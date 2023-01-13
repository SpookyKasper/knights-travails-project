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

  attr_reader :possible_moves
  attr_accessor :position

  def initialize(position = nil)
    @position = position
    @abs_moves = [6, 10, 15, 17]
    @knight_movements = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    @possible_moves = possible_moves
  end

  def possible_moves
    return "you first need to place the knight somewhere in the board before I can tell you the possible moves" if @position.nil?
    possible_moves = []
    @knight_movements.each do |knight_move|
      possible_move = @position.map.with_index do |coordinate, index|
        coordinate + knight_move[index]
      end
      possible_moves << possible_move if possible_move.all? {|coordinate| coordinate.between?(0,7)}
    end
    possible_moves
  end

  def place_knight(row, column)
    @position = [row, column]
  end
end

class KnightGame

  attr_reader :board, :knight, :starting_square

  def initialize(board, knight)
    @board = board
    @knight = knight
  end

  def starting_square(num)
    coordinates = @board.find_coordinates(num)
    row = coordinates[0]
    column = coordinates[1]
    @knight.place_knight(row, column)
  end

  # pseucode for treating possibles moves as nodes in a tree
  # create a node Class that intiliazies with a data, a right node and a left node defaulted to nil
  # create a Tree class with a build tree method
end

class Node

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree

  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  # pseudocode for build_tree method
  # given an array, sort that array, make it have only uniq elements and store it in a variable called sorted
  # find the center of sorted and call it root
  # create a node out root where the data is the value of the center
  # the left is the result of calling build tree on the left part of the array
  # the right is the result of calling build tree on the righ part of the array

  def build_tree(array)
    return if array.empty?
    return Node.new(array[0]) if array.size < 2

    sorted = array.uniq.sort
    center_index = sorted.size / 2
    left_half = sorted[0..center_index-1]
    right_half = sorted[center_index+1..]
    p left_half
    p right_half
    center = sorted[center_index]
    @root = Node.new(center, build_tree(left_half), build_tree(right_half))
  end
end

my_array = [1, 2, 3, 5, 6, 7]
my_tree = Tree.new(my_array)
p my_tree.root


my_game = KnightGame.new(Board.new(8, 8), Knight.new)
my_game.board.display
p my_game.starting_square(47)
p my_game.knight.possible_moves


