# frozen_string_literal: true

VECTORS = {
  forward: [0, 1]
}.freeze

SPECIAL_VECTORS = [
  {
    condition: 'first_move',
    forward: [0, 2]
  },
  {
    condition: 'capture',
    left: [-1, 1],
    right: [1, 1]
  }
].freeze

# Pawn
class Pawn < Piece
  attr_reader :vectors, :special_vectors

  def initialize(color, coordinates)
    super
    @icon = @color == 'white' ? '♟︎' : '♙'
    @starting_coordinates = coordinates
    @vectors = VECTORS
    @special_vectors = SPECIAL_VECTORS
  end

  def condition_met?(condition)
    case condition
    when 'first_move'
      true
    when 'capture'
      true
    else
      false
    end
  end
end
