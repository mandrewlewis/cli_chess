# frozen_string_literal: true

# Queen
class Queen < Piece
  VECTORS = [
    {
      condition: nil,
      forward: [0, 7],
      backward: [0, -7],
      left: [-7, 0],
      right: [7, 0],
      forward_right: [7, 7],
      forward_left: [-7, 7],
      back_right: [7, -7],
      back_left: [-7, -7]
    }
  ].freeze

  attr_reader :vectors

  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♛' : '♕'
    @vectors = VECTORS
    return unless color == 'black'

    @vectors = @vectors.map { |hash| flip_vector(hash) }
  end
end
