# frozen_string_literal: true

require_relative 'board'
require_relative 'piece'
require_relative 'player'
require_relative 'printable'
require_relative 'conversions'

# Manges game flow
class Game
  include Printable
  include Conversions

  attr_reader :players
  attr_accessor :current_player

  def initialize
    @players = []
    @board = Board.new
  end

  def start_game
    print_welcome
    assign_players
    game_loop
  end

  def assign_players
    2.times do |i|
      @players << Player.new(print_request_name(i), i.zero? ? 'white' : 'black')
    end
    @players = @players.cycle
    @current_player = @players.next
  end

  def game_loop
    until game_over?
      piece, target, vector = player_turn
      @board.move_piece(piece, target, vector)
      @current_player = @players.next
    end
    print_game_over
  end

  def player_turn
    loop do
      system('clear')
      @board.display_board
      piece = @board.find_piece(print_request_piece(current_player))
      next unless !piece.nil? && can_move?(current_player, piece)

      target = to_coord_sym(print_request_target(piece))
      vector = piece.valid_move?(target)
      next unless vector

      return [piece, target, vector]
    end
  end

  def can_move?(player, piece)
    piece.color == player.color
  end

  def game_over?
    white_pieces = @board.pieces.select { |p| p.color == 'white' }
    black_pieces = @board.pieces.select { |p| p.color == 'black' }
    kings = @board.pieces.select { |p| p.is_a?(King) }

    white_pieces.empty? || black_pieces.empty? || kings.size < 2 ? true : false
  end
end
