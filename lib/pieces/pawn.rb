# frozen_string_literal: true

# Pawn
class Pawn < Piece
  VECTORS = [
    {
      condition: ->(options) { options[:pieces].none? { |p| p.coordinates == options[:target] } },
      forward: [0, 1]
    },
    {
      condition: ->(_) { @starting_coordinates == @coordinates },
      forward: [0, 2]
    },
    {
      condition: ->(options) { options[:pieces].any? { |p| p.coordinates == options[:target] } }, # TO-DO: en passant
      left: [-1, 1],
      right: [1, 1]
    }
  ].freeze

  attr_reader :vectors, :special_vectors

  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♟︎' : '♙'
    @starting_coordinates = coordinates
    @vectors = VECTORS
  end
end
