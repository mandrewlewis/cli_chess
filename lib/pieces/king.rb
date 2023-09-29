# frozen_string_literal: true

# King
class King < Piece
  VECTORS = [
    {
      condition: nil,
      forward: [0, 1],
      backward: [0, -1],
      left: [-1, 0],
      right: [1, 0],
      forward_right: [1, 1],
      forward_left: [-1, 1],
      back_right: [1, -1],
      back_left: [-1, -1]
    }
  ].freeze

  attr_reader :vectors

  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♚' : '♔'
    @vectors = VECTORS
    return unless color == 'black'

    @vectors = @vectors.map { |hash| flip_vector(hash) }
  end
end
