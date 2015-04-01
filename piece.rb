require 'byebug'
require_relative 'array_helper'

class Piece
  include ArrayHelper

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

  attr_accessor :color, :position, :board

  def initialize(color, board, position)
    @color = color
    @board = board
    @position = position
  end

  def piece_color
    @color == :white ? :black : :black
  end

  def colorize_piece(str)
    str.colorize(piece_color)
  end

  def render
    colorize_piece(PIECES[color][self.class.to_s.downcase.to_sym] + " ")
  end

  def off_board?(pos)
    !pos.all? { |el| el.between?(0, @board.size - 1) }
  end

  def opponent?(other_piece)
    other_piece.color != self.color
  end

  def available_square?(pos)
    @board[pos].nil? || @board[pos].color != self.color
  end

  def move_to(end_pos)
    @board[end_pos] = self
    @board[self.position] = nil
    self.position = end_pos
  end

  def move_into_check?(pos)
    new_board = @board.dup
    new_board.move!(self.position, pos)
    new_board.in_check?(self.color)
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def dup_with_board(board)
    self.class.new(self.color, board, self.position)
  end

end
