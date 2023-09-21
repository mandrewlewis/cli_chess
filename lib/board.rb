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
      color = key[1].to_i < 3 ? 'white' : 'black'
      next if (3..6).include?(key[1].to_i)

      @board_state[key] = Pawn.new(color, key) if %w[2 7].include?(key[1])

      @board_state[key] = new_piece_by_column_letter(color, key) if %w[1 8].include?(key[1])
    end
  end

  def display_board
    system('clear')
    border_string = '  +---+---+---+---+---+---+---+---+'
    columns_string = "    #{[*'a'..'h'].join('   ')}"
    row_count = 8

    puts columns_string
    board_state_icons.each do |row_arr|
      puts border_string
      puts "#{row_count} | #{row_arr.join(' | ')} | #{row_count}"
      row_count -= 1
    end
    puts border_string
    puts columns_string
  end

  def board_state_icons(board_state = @board_state)
    board_state.sort_by { |key, _| [key[1], key[0]] }
               .map { |arr| arr[1].nil? ? ' ' : arr[1].icon }
               .each_slice(8)
               .to_a
               .reverse
  end

  def move_piece(piece, target)
    @board_state[piece.coordinates] = nil
    p piece.coordinates
    piece.move_self(target)
    p piece.coordinates
    @board_state[piece.coordinates] = piece
  end

  private

  def new_piece_by_column_letter(color, coordinates)
    piece = nil
    return piece unless %w[white black].include?(color)

    piece = Rook.new(color, coordinates) if %w[a h].include?(coordinates[0])

    piece = Knight.new(color, coordinates) if %w[b g].include?(coordinates[0])

    piece = Bishop.new(color, coordinates) if %w[c f].include?(coordinates[0])

    piece = Queen.new(color, coordinates) if coordinates[0] == 'd'

    piece = King.new(color, coordinates) if coordinates[0] == 'e'

    piece
  end
end

b = Board.new
b.build_empty_board
b.place_initial_pieces
b.display_board
puts ' '
pawn1 = b.board_state[:a2]
b.move_piece(pawn1, 'a4')
b.display_board
