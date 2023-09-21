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

  def coordinates_to_int_pair(coordinates = @coordinates)
    return coordinates if coordinates.is_a?(Array)

    [
      [*'a'..'h'].find_index(coordinates[0]),
      coordinates[1].to_i - 1
    ]
  end

  def int_pair_to_coord_sym(int_pair)
    return int_pair.downcase.to_sym if int_pair.is_a?(Symbol) || int_pair.is_a?(String)

    column = [*'a'..'h'][int_pair[0]]
    row = (int_pair[1] + 1).to_s
    (column + row).to_sym
  end

  def move_self(target)
    vector = return_valid_vector(target)
    return nil unless valid_move?(target)

    @coordinates = int_pair_to_coord_sym(apply_vector(vector))
  end

  def move!(target)
    @coordinates = int_pair_to_coord_sym(target)
  end

  def apply_vector(vector, coordinates = @coordinates)
    flip_vector(vector) if @color == 'black'
    coord_pair = coordinates_to_int_pair(coordinates)
    [
      coord_pair[0] + vector[0],
      coord_pair[1] + vector[1]
    ]
  end

  def flip_vector(vector)
    vector[1] = -vector[1]
  end

  def valid_move?(target)
    return_valid_vector(target)
  end

  def return_valid_vector(target)
    vector = check_standard_moves(target)
    vector = check_special_moves(target) if vector.nil?
    return nil if vector.nil? || piece_in_path?(target, vector) || out_of_bounds(target)

    vector
  end

  def check_standard_moves(target)
    vector = nil
    @vectors.each_value { |value| vector = value if apply_vector(value) == coordinates_to_int_pair(target) }
    vector
  end

  def check_special_moves(target)
    vector = nil
    @special_vectors.each do |hash|
      next unless condition_met?(hash[:condition])

      hash.each_value do |value|
        next unless value.is_a?(Array)

        vector = value if apply_vector(value) == coordinates_to_int_pair(target)
      end
    end
    vector
  end

  def piece_in_path?(target, vector)
    pointer_coord_pair = coordinates_to_int_pair
    target_coord_pair = coordinates_to_int_pair(target)
    other_pieces = Piece.pieces.reject { |p| p == self }
    until pointer_coord_pair == target_coord_pair
      blocked = other_pieces.any? { |p| p.coordinates == int_pair_to_coord_sym(pointer_coord_pair) }
      return true if blocked || out_of_bounds(pointer_coord_pair)

      pointer_coord_pair = apply_vector(vector, pointer_coord_pair)
    end
    false
  end

  def out_of_bounds(coord_pair)
    coord_pair = coordinates_to_int_pair(coord_pair)
    coord_pair.any? { |c| c.negative? || c > 7 }
  end

  def self.pieces
    @@pieces
  end
end
