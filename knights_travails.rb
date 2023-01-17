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

  attr_reader :possible_moves
  attr_accessor :position

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

  attr_accessor :tree, :root

  def initialize(starting_position)
    @root = Node.new(starting_position)
    @tree = build_tree
  end

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

    # Pseudo for find method
  # Given a goal and a tree search for the goal
  # return the node with the goal is found or nil if not as following:
  # start at the root
  # if the current node data is equal to the goal return the current node
  # if the current node has no children (is a leaf) return
  # otherwise call the find method on each children

  def find(goal, current_node = @root)
    return current_node if current_node.data == goal
    return if current_node.children.nil?

    result = nil
    until current_node.children.empty? || result
      result = find(goal, current_node.children[0])
      return result if result
      current_node.children.shift
    end
  end
end

class KnightGame

  attr_reader :board, :knight, :possible_moves_tree

  def initialize(board, knight)
    @board = board
    @knight = knight
    @possible_moves_tree = nil
  end

  def place_knight_and_make_tree(position)
    @knight.position = position
    @possible_moves_tree = Tree.new(position)
  end
end



my_game = KnightGame.new(Board.new(8, 8), Knight.new)
my_game.board.display
my_game.place_knight_and_make_tree([0, 0])
my_tree = my_game.possible_moves_tree
my_node = my_tree.find([8, 4])
p my_node.data

