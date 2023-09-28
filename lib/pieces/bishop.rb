# frozen_string_literal: true

# Rook
class Bishop < Piece
  VECTORS = [
    {
      condition: nil,
      forward_right: [7, 7],
      forward_left: [-7, 7],
      back_right: [7, -7],
      back_left: [-7, -7]
    }
  ].freeze

  attr_reader :vectors

  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♝' : '♗'
    @vectors = VECTORS
    return unless color == 'black'

    @vectors = @vectors.map { |hash| flip_vector(hash) }
  end
end
