# frozen_string_literal: true

require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'

# Pawn
class Pawn < Piece
  VECTORS = [
    {
      # can't capture forward
      condition: ->(options) { !options[:caller].capturing?(options[:target]) },
      forward: [0, 1]
    },
    {
      # must be first move
      condition: ->(options) { options[:caller].starting_coordinates == options[:caller].coordinates },
      first_forward: [0, 2]
    },
    {
      # must be capturing
      condition: ->(options) { options[:caller].board.find_piece(options[:target]) }, # TO-DO: en passant
      capture_left: [-1, 1],
      capture_right: [1, 1]
    }
  ]

  attr_reader :vectors, :special_vectors

  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♟︎' : '♙'
    @vectors = VECTORS
    return unless color == 'black'

    @vectors = @vectors.map { |hash| flip_vector(hash) }
  end

  def move_self(target, vector)
    @board.destroy_piece(target) if capturing?(target)
    @coordinates = to_coord_sym(apply_vector(vector))
    promotion if is_a?(Pawn) && %w[1 8].include?(@coordinates[1])
  end

  def promotion
    @board.destroy_piece(@coordinates)
    board.pieces << Queen.new(@color, @coordinates, @board)
  end
end
