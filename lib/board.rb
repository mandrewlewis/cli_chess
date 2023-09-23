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
  BORDER_STRING = '  +---+---+---+---+---+---+---+---+'
  COLUMNS_STRING = "    #{[*'a'..'h'].join('   ')}"
  KEYS = [
    %i[a8 b8 c8 d8 e8 f8 g8 h8],
    %i[a7 b7 c7 d7 e7 f7 g7 h7],
    %i[a6 b6 c6 d6 e6 f6 g6 h6],
    %i[a5 b5 c5 d5 e5 f5 g5 h5],
    %i[a4 b4 c4 d4 e4 f4 g4 h4],
    %i[a3 b3 c3 d3 e3 f3 g3 h3],
    %i[a2 b2 c2 d2 e2 f2 g2 h2],
    %i[a1 b1 c1 d1 e1 f1 g1 h1]
  ].freeze

  attr_accessor :pieces

  def initialize
    generate_pieces
    update_pieces
  end

  def generate_pieces
    KEYS.flatten.each do |key|
      color = key[1].to_i < 3 ? 'white' : 'black'

      case key.to_s
      when /\D[3456]/
        next
      when /\D[27]/
        Pawn.new(color, key)
      when /[ah]\d/
        Rook.new(color, key)
      when /[bg]\d/
        Knight.new(color, key)
      when /[cf]\d/
        Bishop.new(color, key)
      when /d\d/
        Queen.new(color, key)
      when /e\d/
        King.new(color, key)
      end
    end
  end

  def update_pieces
    @pieces = Piece.pieces
  end

  def display_board
    update_pieces
    system('clear')
    row_count = 8

    puts COLUMNS_STRING
    icons_by_row.each do |row_arr|
      puts BORDER_STRING, "#{row_count} | #{row_arr.join(' | ')} | #{row_count}"
      row_count -= 1
    end
    puts BORDER_STRING, COLUMNS_STRING
  end

  def icons_by_row
    KEYS.map do |arr|
      arr.map do |key|
        piece = find_piece(key)
        piece ? piece.icon : ' '
      end
    end
  end

  def move_piece(piece, target)
    return nil unless piece.valid_move?(target)

    piece.move_self(target)
    update_pieces
  end

  def find_piece(coordinates)
    @pieces.find { |p| p.coordinates == coordinates.downcase.to_sym }
  end
end

# b = Board.new
# pawn1 = b.find_piece(:a2)
# pawn2 = b.find_piece(:h2)
# knight1 = b.find_piece('b8')
# b.display_board
# sleep(1)

# moves = %i[a4 a5 b6 a6 b7 c8]
# moves.each do |m|
#   b.move_piece(pawn1, m)
#   b.display_board
#   sleep(1)
#   pawn1.valid_move?(m)
# end
