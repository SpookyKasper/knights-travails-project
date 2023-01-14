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

  # def case_exists?(coordinates)
  #   find_square(coordinates[0], coordinates[1])
  # end

  def find_square(coordinates)
    @board[coordinates[0]][coordinates[1]]
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

class Node

  attr_reader :data, :left, :right

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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def build_tree(array)
    return if array.empty?
    return Node.new(array[0]) if array.size < 2

    sorted = array.uniq.sort
    center_index = sorted.size / 2
    left_half = sorted[0..center_index-1]
    right_half = sorted[center_index+1..]
    center = sorted[center_index]
    Node.new(center, build_tree(left_half), build_tree(right_half))
  end

  # pseudo for inorder
  # given a tree start at the root
  # if the current node is nil return
  # if both left and right child are nil, push the data to the result array
  # call the inorder on the left child
  # push the current node data to the result
  # call the inorder on the righ child

  def inorder(current_node = @root, result = [])
    return if current_node.nil?
    result << current_node.data and return result if current_node.left.nil? && current_node.right.nil?
    inorder(current_node.left, result)
    result << current_node.data
    inorder(current_node.right, result)
  end
end

class KnightGame

  attr_reader :board, :knight, :knight_possibles

  def initialize(board, knight)
    @board = board
    @knight = knight
    @possible_moves = nil
  end

  def def_starting_square_num(num)
    coordinates = @board.find_coordinates(num)
    row = coordinates[0]
    column = coordinates[1]
    @knight.place_knight(row, column)
  end

  def def_starting_square_coo(coordinates)
    @knight.place_knight(coordinates[0], coordinates[1])
  end

  # pseudocode for knight_moves(start, end, path = [])
  # given a start and an end square find the shortest path to it
  # declare an empty array called path = []
  # push the start_square to the array
  # check all the possible moves from the start square
  # if one of the moves is the end square push it to the path and return the path
  # if none of the moves is the end square
  # recursively call knight_noves on each node

  def search_end_square(end_square, current_node = @possible_moves.root)
    return if current_node.nil?
    return end_square if current_node.data == end_square
    end_square < current_node.data ? search_end_square(end_square, current_node.left) : search_end_square(end_square, current_node.right)
  end


  def knight_moves(start_square, end_square, path = [start_square])
    @knight.place_knight(start_square[0], start_square[1])
    num_end = @board.find_square(end_square)
    @possible_moves = Tree.new(knight.possible_moves.map {|move| @board.find_square(move)})
    # possible_moves.pretty_print
    result = search_end_square(num_end)
    path << @board.find_coordinates(result) and return path unless result.nil?
    possible_moves.inorder.each do |square|
      knight_moves(@board.find_coordinates(square), end_square)
    end
  end
end


my_game = KnightGame.new(Board.new(8, 8), Knight.new([4, 0]))
my_game.board.display
p my_game.knight_moves([0, 0], [1, 2])



