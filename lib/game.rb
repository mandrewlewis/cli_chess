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

  attr_reader :players, :board, :check, :mate
  attr_accessor :current_player, :error, :flash, :previous_move

  def initialize
    @players = []
    @board = Board.new(self)
    @flash = nil
    @previous_move = nil
    @check = false
    @mate = false
  end

  def start_game
    dev_setup_method
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
      capture = piece.capturing?(target)
      @flash = ['notice', "#{capture.color.capitalize} #{capture.class.to_s.downcase} captured!"] if capture
      @board.move_piece(piece, target, vector)
      @current_player = @players.next
      @previous_move = [piece, target, vector]
      @check = check?
      @mate = check_mate? if @check

      if @check
        @flash = @flash.nil? ? ['notice', 'Check!'] : @flash.push('Check!')
      end
    end
    print_game_over
  end

  def player_turn
    loop do
      system('clear')
      @board.display_board
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
    vector = piece.valid_move?(target) unless piece.out_of_bounds?(target)
    if target.nil? || piece.out_of_bounds?(target)
      @flash = ['error', 'Not a valid target']
    elsif vector.nil?
      @flash = ['error', 'Not a valid move']
    elsif @check && !check_resolved?(piece, target)
      @flash = ['error', 'Must get out of check']
    end
    [target, vector]
  end

  def check?
    king = board.pieces.find { |p| p.is_a?(King) && p.color == current_player.color }
    @previous_move[0].valid_move?(king.coordinates)
  end

  def check_resolved?(piece, target)
    king = board.pieces.find { |p| p.is_a?(King) && p.color == current_player.color }
    king_moved_out_of_check?(piece, target, king) ||
      captured_attacker?(piece, target) ||
      piece_in_path_to_king?(piece, target, king)
  end

  def king_moved_out_of_check?(piece, target, king)
    return false unless piece == king

    opp_pieces = board.pieces.reject { |p| p.color == current_player.color }
    opp_pieces.each { |opp| return false if opp.valid_move?(target) }
    true
  end

  def captured_attacker?(piece, target)
    piece.capturing?(target) == @previous_move[0]
  end

  def piece_in_path_to_king?(piece, target, king)
    prev_coord = piece.coordinates
    piece.coordinates = target
    blocked = !@previous_move[0].valid_move?(king.coordinates)
    piece.coordinates = prev_coord
    blocked
  end

  def check_mate?
    player_pieces = board.pieces.select { |p| p.color == current_player.color }
    player_pieces.each do |p|
      valid_moves = @board.keys.flatten.select { |k| p.valid_move?(k) }
      valid_moves.each { |vm| return false if check_resolved?(p, vm) }
    end
    true
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

  def dev_setup_method
    remove_pieces = %i[]
    @board.pieces.reject! { |p| remove_pieces.include?(p.coordinates) }
    # @board.find_piece(:a7).move_self(:a6, [0, -1]) # en passant setup
  end
end
