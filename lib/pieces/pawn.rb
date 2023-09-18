# frozen_string_literal: true

# Pawn
class Pawn < Piece
  def initialize(color)
    super
    @icon = @color == 'white' ? '♟︎' : '♙'
  end
end
