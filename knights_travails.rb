class Board
  attr_accessor :board

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @board = build_board(rows, columns)
  end

  def display
    @board.each { |row| p row }
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
    @knight_movements = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    @possible_moves = possible_moves
  end

  def place_knight(coordinates)
    row = coordinates[0]
    column = coordinates[1]
    @position = [row, column]
  end

  def possible_moves
    return 'you first need to place the knight somewhere in the board before I can tell you the possible moves' if @position.nil?

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
    @board = Board.new(8, 8)
    @knight = Knight.new
    @left = (1..64).to_a
    @root = build_tree(Node.new(starting_position))
  end

  def build_tree(root_node, current_node = root_node, queue = [])
    return root_node if @left.empty?

    @knight.place_knight(current_node.data)
    possible_moves = @knight.possible_moves
    moves_nodes = possible_moves.map { |move| Node.new(move) }
    numbered_moves = possible_moves.map { |move| @board.find_square(move) }
    moves_nodes.each_with_index { |move, i| current_node.children << move && queue << move if @left.include?(numbered_moves[i]) }
    @left.delete(@board.find_square(current_node.data))
    numbered_moves.each { |move| @left.delete(move) }
    queue.shift
    build_tree(root_node, queue[0], queue)
  end

  def find(goal, current_node = @root, result = nil)
    return current_node if current_node.data == goal
    return if current_node.children.nil?

    until current_node.children.empty? || result
      result = find(goal, current_node.children[0])
      return result if result

      current_node.children.shift
    end
  end

  def search_and_path(goal, current_node = @root, path = [current_node.data])
    return path if current_node.data == goal

    current_node.children.map(&:data)
    ancestor = current_node.children.select { |child| find(goal, child) }
    path << ancestor[0].data
    search_and_path(goal, ancestor[0], path)
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

  def knight_moves(start, goal)
    place_knight_and_make_tree(start)
    path = @possible_moves_tree.search_and_path(goal)
    puts "You made it in #{path.length - 1} moves! Here's your path"
    path.each { |move| p move }
  end
end
mytree = Tree.new([0, 0])

my_game = KnightGame.new(Board.new(8, 8), Knight.new)
my_game.board.display
my_game.knight_moves([0, 0], [3, 3])
