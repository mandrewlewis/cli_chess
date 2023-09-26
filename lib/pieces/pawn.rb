# frozen_string_literal: true

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
end
