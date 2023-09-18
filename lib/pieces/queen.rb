# frozen_string_literal: true

# Queen
class Queen < Piece
  def initialize(color)
    super
    @icon = @color == 'white' ? '♛' : '♕'
  end
end
