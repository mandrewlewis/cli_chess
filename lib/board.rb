# frozen_string_literal: true

require_relative 'piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'

# Stores board state and actions
class Board
  attr_reader :board_state

  def initialize
    @board_state = {}
  end

  def build_empty_board
    8.times do |row|
      [*'a'..'h'].each do |col|
        @board_state["#{col}#{row + 1}".to_sym] = nil
      end
    end
    @board_state
  end

  def place_initial_pieces
    @board_state.each_key do |key|
      coordinates = symbol_to_col_row_pair(key)
      color = coordinates[1].to_i < 3 ? 'white' : 'black'
      next if (3..6).include?(coordinates[1].to_i)

      @board_state[key] = Pawn.new(color) if %w[2 7].include?(coordinates[1])

      @board_state[key] = return_piece_by_column_letter(coordinates[0], color) if %w[1 8].include?(coordinates[1])
    end
  end

  def display_board
    system('clear')
    output_string = <<-HEREDOC
           a   b   c   d   e   f   g   h
         +---+---+---+---+---+---+---+---+
      8  |   |   |   |   |   |   |   |   |  8
         +---+---+---+---+---+---+---+---+
      7  |   |   |   |   |   |   |   |   |  7
         +---+---+---+---+---+---+---+---+
      6  |   |   |   |   |   |   |   |   |  6
         +---+---+---+---+---+---+---+---+
      5  |   |   |   |   |   |   |   |   |  5
         +---+---+---+---+---+---+---+---+
      4  |   |   |   |   |   |   |   |   |  4
         +---+---+---+---+---+---+---+---+
      3  |   |   |   |   |   |   |   |   |  3
         +---+---+---+---+---+---+---+---+
      2  |   |   |   |   |   |   |   |   |  2
         +---+---+---+---+---+---+---+---+
      1  |   |   |   |   |   |   |   |   |  1
         +---+---+---+---+---+---+---+---+
           a   b   c   d   e   f   g   h

    HEREDOC
    puts output_string
  end

  private

  def symbol_to_col_row_pair(sym)
    sym.to_s.split('')
  end

  def return_piece_by_column_letter(column_letter, color)
    piece = nil
    piece = Rook.new(color) if %w[a h].include?(column_letter)

    piece = Knight.new(color) if %w[b g].include?(column_letter)

    piece = Bishop.new(color) if %w[c f].include?(column_letter)

    piece = Queen.new(color) if column_letter == 'd'

    piece = King.new(color) if column_letter == 'e'

    piece
  end
end

b = Board.new
b.build_empty_board
b.place_initial_pieces
p b.board_state
