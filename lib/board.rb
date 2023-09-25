# frozen_string_literal: true

require_relative 'piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'conversions'

# Stores board state and actions
class Board
  include Conversions

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
    @pieces = []
    generate_pieces
  end

  def generate_pieces
    KEYS.flatten.each do |key|
      color = key[1].to_i < 3 ? 'white' : 'black'

      case key.to_s
      when /\D[3456]/
        next
      when /\D[27]/
        @pieces <<  Pawn.new(color, key, self)
      when /[ah][18]/
        @pieces <<  Rook.new(color, key, self)
      when /[bg][18]/
        @pieces << Knight.new(color, key, self)
      when /[cf][18]/
        @pieces << Bishop.new(color, key, self)
      when /d[18]/
        @pieces << Queen.new(color, key, self)
      when /e[18]/
        @pieces << King.new(color, key, self)
      end
    end
  end

  def display_board
    row_count = 8

    puts COLUMNS_STRING
    icons_by_row.each do |row_arr|
      puts BORDER_STRING, "#{row_count} | #{row_arr.join(' | ')} | #{row_count}"
      row_count -= 1
    end
    puts BORDER_STRING, COLUMNS_STRING, ''
  end

  def icons_by_row
    KEYS.map do |arr|
      arr.map do |key|
        piece = find_piece(key)
        piece ? piece.icon : ' '
      end
    end
  end

  def find_piece(coordinates)
    return nil if coordinates.nil?

    @pieces.find { |p| p.coordinates == to_coord_sym(coordinates) }
  end

  def move_piece(piece, target, vector)
    piece.move_self(target, vector)
  end

  def destroy_piece(coordinates)
    @pieces.reject! { |p| p.coordinates == to_coord_sym(coordinates) }
  end
end
