require 'dispel'
require_relative 'board'
require_relative 'chess_helper'
require 'yaml'

class ChessGame

  include ChessHelper

  def self.play
  end

  def self.load
    YAML.load_file(file_path_name)
  end

  def initialize(board = YAML.load_file('starting_positions.yaml'))
    @board = board
    @turn = :white
  end

  def run
    until @board.checkmate?(@turn)
      puts @board.render
      begin
        from, to = get_user_input
        @board.move(from, to)
      rescue
        retry
      end
      @turn = opposite_color(@turn)
    end

    puts @board.render

    puts "Checkmate!"
  end

  def get_user_input
    puts "Enter move from, move to: "
    input = gets.chomp
    parse(input)
  end

  def parse(input)
    from_pos, to_pos = input.split(" ")
    from_pos = [num_to_row(from_pos[1]), char_to_col(from_pos[0])]
    to_pos = [num_to_row(to_pos[1]), char_to_col(to_pos[0])]
    [from_pos, to_pos]
  end

  def char_to_col(char)
    char.downcase.ord - "a".ord
  end

  def num_to_row(num)
    8 - num.to_i
  end

  def load(file_path_name)
    @board = ChessGame.load(file_path_name)
  end

end

if __FILE__ == $PROGRAM_NAME
  game = ChessGame.new
  game.run
end
