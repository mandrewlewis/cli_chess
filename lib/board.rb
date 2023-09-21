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

  BORDER_STRING = '  +---+---+---+---+---+---+---+---+'
  COLUMNS_STRING = "    #{[*'a'..'h'].join('   ')}"

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
    row_count = 8

    puts COLUMNS_STRING
    board_state_icons.each do |row_arr|
      puts BORDER_STRING
      puts "#{row_count} | #{row_arr.join(' | ')} | #{row_count}"
      row_count -= 1
    end
    puts BORDER_STRING, COLUMNS_STRING
  end

  def board_state_icons(board_state = @board_state)
    board_state.sort_by { |key, _| [key[1], key[0]] }
               .map { |arr| arr[1].nil? ? ' ' : arr[1].icon }
               .each_slice(8)
               .to_a
               .reverse
  end

  def move_piece(piece, target)
    return nil unless piece.valid_move?

    @board_state[piece.coordinates] = nil
    piece.move!(target)
    @board_state[piece.coordinates] = piece
  end

  def find_piece(coordinates)
    @board_state[coordinates.downcase.to_sym]
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
pawn1 = b.find_piece(:a2)
pawn2 = b.find_piece(:h2)
knight1 = b.find_piece('b8')
b.display_board


p pawn1.valid_move?(:a4)

# b.display_board
# sleep(0.5)
# b.move_piece(pawn1, :a3)

# b.display_board
# sleep(0.5)
# b.move_piece(knight1, 'c6')

# b.display_board
# sleep(0.5)
# b.move_piece(pawn2, 'h4')

# b.display_board
# sleep(0.5)
# b.move_piece(knight1, 'b4')

# b.display_board
# sleep(0.5)
# b.move_piece(pawn1, 'b4')

# b.display_board
