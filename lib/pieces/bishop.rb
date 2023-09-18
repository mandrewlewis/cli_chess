# frozen_string_literal: true

# Bishop
class Bishop < Piece
  def initialize(color)
    super
    @icon = @color == 'white' ? '♝' : '♗'
  end
end
