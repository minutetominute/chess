class Piece

  PIECES = {
    :white => {
      king:	 "\u2654", #♔
      queen: "\u2655", #♕
      rook:  "\u2656", #♖
      bishop:"\u2657", #♗
      knight:"\u2658", #♘
      pawn:  "\u2659"  #♙
  },

    :black => {
      king:	 "\u265A", #♔
      queen: "\u265B", #♕
      rook:  "\u265C", #♖
      bishop:"\u265D", #♗
      knight:"\u265E", #♘
      pawn:  "\u265F"  #♙
    }
  }

  attr_reader :color, :position

  def initialize(color, board, position)
    @color = color
    @board = board
    @postion = position
  end

  def moves
    raise NotImplementedError
  end

  def display
    PIECES[color][self.class.to_s.downcase.to_sym] + " "
  end

  protected
  attr_reader :board
  attr_writer :position
end

class SlidingPiece < Piece

  DIAGONAL_DIRS = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
  ORTHOGONAL_DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1]]

  def moves
    available_moves = [self.position]
    last_move = available_moves.last

    move_dirs.each do |dir|
      until off_board?(last_move) || on_other_piece?(last_move)
        last_move = available_moves.last
        available_moves << [last_move[0] + dir[0], last_move[1] + dir[1]]
      end
      available_moves << [self.position]
    end

    available_moves.delete([self.position])

    available_moves
  end

  def move_dirs
    raise NotImplementedError
  end
end

class Bishop < SlidingPiece

  def move_dirs
    DIAGONAL_DIRS
  end
end

class Rook < SlidingPiece
  def move_dirs
    ORTHOGONAL_DIRS
  end
end

class Queen < SlidingPiece
  def move_dirs
    DIAGONAL_DIRS + ORTHOGONAL_DIRS
  end
end

class SteppingPiece < Piece

end

class Knight < SteppingPiece

end

class King < SteppingPiece

end

class Pawn < Piece

end
