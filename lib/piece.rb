# frozen_string_literal: true

# Generic piece
class Piece
  attr_reader :icon, :color

  def initialize(color)
    @color = color
  end
end
