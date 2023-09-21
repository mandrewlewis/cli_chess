# frozen_string_literal: true

VECTORS = {
  forward: [0, 1]
}.freeze

SPECIAL_VECTORS = {
  first_move: {
    condition: 'must be first move and nothing in the way',
    forward: [[0, 2]]
  },
  capture: {
    condition: 'Must capture. En Passant: opponent must use pawn first_move immediately prior and must be adjecent',
    left: [-1, 1],
    right: [1, 1]
  }
}.freeze

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
end
