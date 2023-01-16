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

class KnightGame

  attr_reader :board, :knight

  def initialize(board, knight)
    @board = board
    @knight = knight
  end

  # pseudocode for make tree:
  # given a starting square make a tree of the possible moves
  # place the night at the current_square
  # delete the current square from the left array
  # make an array of all the possible moves from that position
  # push a numbered version of all those moves tho the queueq

  def make_tree(current_square, left = (1..64).to_a, queue = [current_square.data])
    # return if all the square have been visited
    return if left.empty?

    # place the knight on the first element of the queue
    @knight.place_knight(queue[0])
    # delete the number of that square from the left array
    left.delete(@board.find_square(queue[0]))
    # make an array of the possible moves called moves
    moves = @knight.possible_moves
    # push each move to the queue unless their numbered version is not in left
    moves.each {|move| queue << move if left.include?(@board.find_square(move))}
    # make a number version of each move
    num_moves = moves.map {|move| @board.find_square(move)}
    # delete that number from the left array
    num_moves.each {|num| left.delete(num)}
    # shift the first element of queue
    queue.shift
    make_tree(queue[0], left, queue)
  end

end



my_game = KnightGame.new(Board.new(8, 8), Knight.new)
my_game.board.display
my_game.make_tree(Node.new([0,0]))





