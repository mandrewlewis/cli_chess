# frozen_string_literal: true

# Rook
class Rook < Piece
  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♜' : '♖'
  end
end
