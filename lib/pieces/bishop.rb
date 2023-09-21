# frozen_string_literal: true

# Bishop
class Bishop < Piece
  def initialize(color, coordinates)
    super
    @icon = @color == 'white' ? '♝' : '♗'
  end
end
