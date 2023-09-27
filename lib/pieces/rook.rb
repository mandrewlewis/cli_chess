# frozen_string_literal: true

# Rook
class Rook < Piece
  VECTORS = [
    {
      condition: nil,
      forward: [0, 7],
      backward: [0, -7],
      left: [-7, 0],
      right: [7, 0]
    }
  ].freeze

  attr_reader :vectors

  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♜' : '♖'
    @vectors = VECTORS
    return unless color == 'black'

    @vectors = @vectors.map { |hash| flip_vector(hash) }
  end
end
