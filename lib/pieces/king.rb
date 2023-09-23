# frozen_string_literal: true

# King
class King < Piece
  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♚' : '♔'
  end
end
