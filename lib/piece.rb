# frozen_string_literal: true

# Generic piece
class Piece
  attr_accessor :coordinates
  attr_reader :icon, :color, :in_play

  @@pieces = []

  def initialize(color, coordinates)
    @color = color
    @coordinates = coordinates
    @in_play = true
    @@pieces << self
  end

  def coordinates_to_int_pair
    [
      [*'a'..'h'].find_index(@coordinates[0]),
      @coordinates[1].to_i - 1
    ]
  end

  def int_pair_to_coord_sym(int_pair)
    column = [*'a'..'h'][int_pair[0]]
    row = (int_pair[1] + 1).to_s
    (column + row).to_sym
  end

  def move_self(target)
    @coordinates = target.is_a?(Array) ? int_pair_to_coord_sym(target) : target.downcase.to_sym
  end

  def self.pieces
    @@pieces
  end
end
