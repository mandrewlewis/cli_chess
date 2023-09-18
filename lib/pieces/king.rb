# frozen_string_literal: true

# King
class King < Piece
  def initialize(color)
    super
    @icon = @color == 'white' ? '♚' : '♔'
  end
end
