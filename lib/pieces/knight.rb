# frozen_string_literal: true

# Knight
class Knight < Piece
  VECTORS = [
    {
      condition: nil,
      forward_right: [1, 2],
      forward_left: [-1, 2],
      back_right: [1, -2],
      back_left: [-1, -2],
      right_forward: [2, 1],
      right_back: [2, -1],
      left_forward: [-2, 1],
      left_back: [-2, -1]
    }
  ].freeze

  attr_reader :vectors

  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♞' : '♘'
    @vectors = VECTORS
    return unless color == 'black'

    @vectors = @vectors.map { |hash| flip_vector(hash) }
  end
end
