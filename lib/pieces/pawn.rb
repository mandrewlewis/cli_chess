# frozen_string_literal: true

VECTORS = [
  {
    condition: 'target_unoccupied',
    forward: [0, 1]
  },
  {
    condition: 'first_move',
    forward: [0, 2]
  },
  {
    condition: 'capturing',
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
  end

  def condition_met?(condition)
    case condition
    when ''
      true
    when 'target_unoccupied'
      true
    when 'first_move'
      true
    when 'capturing'
      # en passant here
      true
    else
      false
    end
  end
end
