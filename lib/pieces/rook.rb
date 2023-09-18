# frozen_string_literal: true

# Rook
class Rook < Piece
  def initialize(color)
    super
    @icon = @color == 'white' ? '♜' : '♖'
  end
end
