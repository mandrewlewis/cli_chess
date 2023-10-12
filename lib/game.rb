# frozen_string_literal: true

require_relative 'board'
require_relative 'pieces/piece'
require_relative 'player'
require_relative 'printable'
require_relative 'conversions'
require_relative 'check_checker'

# Manges game flow
class Game
  include Printable
  include Conversions
  include CheckChecker

  attr_reader :players, :board, :mate
  attr_accessor :current_player, :error, :flash, :previous_move, :check

  def initialize
    @players = []
    @board = Board.new(self)
    @flash = nil
    @previous_move = nil
    @check = false
    @mate = false
  end

  def start_game
    print_welcome
    assign_players
    game_loop
  end

  private

  def assign_players
    2.times { |i| @players << Player.new(print_request_name(i), i.zero? ? 'white' : 'black') }
    @players = @players.cycle
    @current_player = @players.next
  end

  def game_loop
    until game_over?
      piece, target, vector = player_turn

      capture = piece.capturing?(target)
      @flash = ['notice', "#{capture.color.capitalize} #{capture.class.to_s.downcase} captured!"] if capture

      piece.handle_castling(target, vector) if piece.is_a?(King)

      setup_next_turn(piece, target, vector)

      @flash = @flash.nil? ? ['notice', 'Check!'] : @flash.push('Check!') if @check
    end
    print_game_over(@players.next, @board)
  end

  def player_turn
    loop do
      system('clear')
      display_board(@board)
      flash_msg

      piece = request_piece
      next if @flash

      target, vector = request_target(piece)
      next if @flash

      return [piece, target, vector]
    end
  end

  def request_piece
    piece = @board.find_piece(print_request_piece(@current_player))
    if piece.nil?
      @flash = ['error', 'No such piece']
    elsif piece.color != current_player.color
      @flash = ['error', 'Not your piece']
    end
    piece
  end

  def request_target(piece)
    target = to_coord_sym(print_request_target(piece))
    vector = piece.valid_move?(target, piece.coordinates, true) unless piece.out_of_bounds?(target)
    if target.nil? || piece.out_of_bounds?(target)
      @flash = ['error', 'Not a valid target']
    elsif vector.nil?
      @flash = ['error', 'Not a valid move']
    elsif @check && !check_resolved?(piece, target)
      @flash = ['error', 'Must get out of check']
    end
    [target, vector]
  end

  def setup_next_turn(piece, target, vector)
    @board.move_piece(piece, target)
    @current_player = @players.next
    @previous_move = [piece, target, vector]
    @check = check?
    @mate = check_mate? if @check
  end

  def game_over?
    white_pieces = @board.pieces.select { |p| p.color == 'white' }
    black_pieces = @board.pieces.select { |p| p.color == 'black' }
    kings = @board.pieces.select { |p| p.is_a?(King) }

    white_pieces.empty? || black_pieces.empty? || kings.size < 2 || @mate
  end

  def flash_msg
    return if @flash.nil?

    @flash[0] == 'notice' ? print_flash_notice(@flash) : print_flash_error(@flash)
    @flash = nil
  end
end
