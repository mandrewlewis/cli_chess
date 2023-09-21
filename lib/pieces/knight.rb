# frozen_string_literal: true

# Knight
class Knight < Piece
  def initialize(color, coordinates)
    super
    @icon = @color == 'white' ? '♞' : '♘'
  end
end
