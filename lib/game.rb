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
      piece, target = player_turn
      # move
      # check win conditions
      @current_player = @players.next
    end
  end

  def player_turn
    loop do
      system('clear')
      @board.display_board
      piece = @board.find_piece(print_request_piece(current_player))
      next unless !piece.nil? && can_move?(current_player, piece)

      target = print_request_target(piece)
      next unless piece.valid_move?(to_coord_sym(target))

      return [piece, target]
    end
  end

  def can_move?(player, piece)
    piece.color == player.color
  end

  def game_over?
    false
  end
end
