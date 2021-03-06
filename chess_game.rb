require 'dispel'
require_relative 'board'
require_relative 'chess_helper'
require 'yaml'
require_relative 'error'
require_relative 'player'

class ChessGame

  include ChessHelper

  def self.play
  end

  def self.load(file_path_name)
    YAML.load_file(file_path_name)
  end

  def self.default
    YAML.load_file('starting_positions.yaml')
  end

  def initialize(board, white_player, black_player)
    @board = board
    @turn = :white
    @white_player = white_player
    @black_player = black_player
  end

  def run
    until @board.checkmate?(@turn)
      puts @board.render
      begin
        input = get_player_input(@board)
        if input == "save"
          save
          next
        else
          from, to = input
        end
        raise EmptySquareError if @board[from].nil?
        raise NotYourPieceError if @board[from].color != @turn
        @board.move(from, to)
      rescue EmptySquareError => e
        puts "No piece on that square."
        retry
      rescue NotYourPieceError => e
        puts "That is not your piece."
        retry
      rescue MoveNotAvailableError => e
        retry
      end
      @turn = opposite_color(@turn)
    end

    puts @board.render

    puts "Checkmate!"
  end

  def get_player_input(board)
    current_player.play_turn(board)
  end

  def current_player
    @turn == :white ? @white_player : @black_player
  end

  def save
    File.write("chess_game_save.yaml", @board.to_yaml)
  end

  def load(file_path_name)
    @board = ChessGame.load(file_path_name)
  end

end

if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new(:white)
  p2 = ComputerPlayer.new(:black)
  board = ChessGame.default
  game = ChessGame.new(board, p1, p2)

  game.run
end
