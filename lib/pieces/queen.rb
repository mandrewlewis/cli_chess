# frozen_string_literal: true

# Queen
class Queen < Piece
  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♛' : '♕'
  end
end
