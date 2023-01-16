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

  attr_reader :possible_moves, :position

  def initialize(position = nil)
    @position = position
    @abs_moves = [6, 10, 15, 17]
    @knight_movements = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    @possible_moves = possible_moves
  end

  def place_knight(coordinates)
    row = coordinates[0]
    column = coordinates[1]
    @position = [row, column]
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
end

class Node
  attr_accessor :data, :children

  def initialize(data)
    @data = data
    @children = []
  end
end

class Tree

  attr_reader :tree,  :root

  def initialize(starting_position)
    @root = Node.new(starting_position)
    @tree = build_tree
  end

  # pseudocode for building tree
  # given a starting position return a Tree of the possible moves as following:
  # declare an array from 1 to 64
  # if left is empty return
  # make a node out of the  position
  # make a knight place at the positon
  #
  def build_tree(current_node = @root, board = Board.new(8, 8), left = (1..64).to_a, queue = [])
    return @root if left.empty?

    knight = Knight.new(current_node.data)
    current_num = board.find_square(current_node.data)

    possible_moves = knight.possible_moves
    moves_nodes = possible_moves.map {|move| Node.new(move)}
    numbered_moves = possible_moves.map {|move| board.find_square(move)}

    moves_nodes.each_with_index {|move, index| current_node.children << move if left.include?(numbered_moves[index])}

    left.delete(current_num)
    numbered_moves.each {|move| left.delete(move)}

    queue.shift
    moves_nodes.each {|node| queue << node}
    build_tree(queue[0], board, left, queue)
  end
end

class KnightGame

  attr_reader :board, :knight, :tree

  def initialize(board, knight)
    @board = board
    @knight = knight
    # @tree = make_tree(Node.new([0, 0]))
  end

  # pseudocode for

  # pseudocode for make tree:
  # given a starting square make a tree of the possible moves
  # place the night at the current_square
  # delete the current square from the left array
  # make an array of all the possible moves from that position
  # push a numbered version of all those moves tho the queueq

  # def make_tree(current_square, left = (1..64).to_a, queue = [current_square])
  #   puts "this is the current square #{current_square.data}"
  #   puts "this is the current queue #{queue}"
  #   # return if all the square have been visited
  #   return if left.empty?

  #   # place the knight on the first element of the queue
  #   position = @knight.place_knight(queue[0].data)
  #   puts "this is the current knight position #{position}"
  #   # delete the number of that square from the left array
  #   left.delete(@board.find_square(position))
  #   puts "this is the numbers left in left #{left}"
  #   # make an array of the possible moves called moves
  #   moves = @knight.possible_moves
  #   puts "this is the possibles moves of the knight #{moves}"
  #   # make nodes out of each move
  #   move_nodes = moves.map {|move| Node.new(move)}
  #   puts "this is are the move nodes #{move_nodes}"
  #   move_nodes.each {|move| current_square.children << move}
  #   puts "this is the current square after adding the children #{current_square.children}"
  #   move_nodes.each {|move| queue << move if left.include?(@board.find_square(move.data))}
  #   # make a number version of each move
  #   num_moves = moves.map {|move| @board.find_square(move)}
  #   # delete that number from the left array
  #   num_moves.each {|num| left.delete(num)}
  #   # shift the first element of queue
  #   queue.shift
  #   make_tree(queue[0], left, queue)
  # end
end



my_game = KnightGame.new(Board.new(8, 8), Knight.new)
my_game.board.display
my_tree = Tree.new([2, 2])
p my_tree.root







