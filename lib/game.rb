# frozen_string_literal: true

require_relative 'board'
require_relative 'piece'
require_relative 'player'
require_relative 'printable'

# Manges game flow
class Game
  include Printable

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
      print_request_name(i)
      @players << Player.new(gets.chomp, i.zero? ? 'white' : 'black')
    end
    @players = @players.cycle
    @current_player = @players.next
  end

  def game_loop
    until game_over?
      system('clear')
      @board.display_board
      piece, target = player_turn
      # move
      # check win conditions
      @current_player = @players.next
    end
  end

  def player_turn
    print_request_piece(current_player)
    piece = @board.find_piece(gets.chomp)
    print_request_target(piece)
    target = gets.chomp
    [piece, target]
  end

  def game_over?
    false
  end
end
