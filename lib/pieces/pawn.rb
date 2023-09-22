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

  def condition_met?(condition, target = nil)
    case condition
    when ''
      true
    when 'target_unoccupied'
      target_unoccupied?(target)
    when 'first_move'
      first_move?
    when 'capturing'
      capturing?(target)
    else
      false
    end
  end

  private

  def target_unoccupied?(target)
    @@pieces.none? { |p| p.coordinates == int_pair_to_coord_sym(target) }
  end

  def first_move?
    @starting_coordinates == @coordinates
  end

  def capturing?(target)
    # TO-DO: en passant
    @@pieces.any? { |p| p.coordinates == int_pair_to_coord_sym(target) }
  end
end
