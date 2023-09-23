# frozen_string_literal: true

# Bishop
class Bishop < Piece
  def initialize(color, coordinates, board)
    super
    @icon = @color == 'white' ? '♝' : '♗'
  end
end
