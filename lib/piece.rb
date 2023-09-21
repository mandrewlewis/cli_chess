# frozen_string_literal: true

# Generic piece
class Piece
  attr_accessor :coordinates
  attr_reader :icon, :color

  def initialize(color, coordinates)
    @color = color
    @coordinates = coordinates
  end

  def coordinates_to_int_pair
    [
      [*'a'..'h'].find_index(@coordinates[0]),
      @coordinates[1].to_i - 1
    ]
  end

  def int_pair_to_coord_str(int_pair)
    column = [*'a'..'h'][int_pair[0]]
    row = (int_pair[1] + 1).to_s
    column + row
  end

  def int_pair_to_coord_sym(int_pair)
    int_pair_to_coord_str(int_pair).to_sym
  end
end
