# frozen_string_literal: true

# Pawn
class Pawn < Piece
  def initialize(color, coordinates)
    super
    @icon = @color == 'white' ? '♟︎' : '♙'
  end
end
