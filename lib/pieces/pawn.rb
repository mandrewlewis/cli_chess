# frozen_string_literal: true

require_relative 'queen'
require_relative '../conversions'

# Pawn
class Pawn < Piece
  include Conversions

  VECTORS = [
    {
      # can't capture forward
      condition: ->(options) { !options[:caller].capturing?(options[:target]) },
      forward: [0, 1]
    },
    {
      # must be first move
      condition: ->(options) { options[:caller].first_move && !options[:caller].capturing?(options[:target]) },
      first_forward: [0, 2]
    },
    {
      # must be capturing
      condition: ->(options) { options[:caller].board.find_piece(options[:target]) },
      capture_left: [-1, 1],
      capture_right: [1, 1]
    },
    {
      # en passant
      condition: ->(options) { options[:caller].en_passant?(options[:target]) },
      capture_left: [-1, 1],
      capture_right: [1, 1]
    }
  ].freeze

  attr_reader :vectors

  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♟︎' : '♙'
    @vectors = VECTORS
    return unless color == 'black'

    @vectors = @vectors.map { |hash| flip_vector(hash) }
  end

  def move_self(target)
    @first_move = false
    @board.destroy_piece(target) if capturing?(target)
    preform_en_passant if en_passant?(target)
    @coordinates = target
    promotion if is_a?(Pawn) && %w[1 8].include?(@coordinates[1])
  end

  def promotion
    @board.destroy_piece(@coordinates)
    board.pieces << Queen.new(@color, @coordinates, @board)
  end

  def en_passant?(player_target)
    piece, target, vector = @board.game.previous_move
    return if piece.nil?

    coord_sym_adjacents(target).include?(@coordinates) &&
      piece.color != @color &&
      vector[1].abs == 2 &&
      player_target[0] == target[0]
  end

  def preform_en_passant
    piece, target = @board.game.previous_move
    @board.destroy_piece(target)
    @board.game.flash = ['notice', "#{piece.color.capitalize} #{piece.class.to_s.downcase} captured!"]
  end
end
