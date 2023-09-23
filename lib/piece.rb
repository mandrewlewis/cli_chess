# frozen_string_literal: true

# Generic piece
class Piece
  attr_accessor :coordinates
  attr_reader :icon, :color, :in_play, :board

  def initialize(color, coordinates, board)
    @color = color
    @coordinates = coordinates
    @board = board
    @in_play = true
  end

  def to_int_pair(coordinates = @coordinates)
    return nil if out_of_bounds?(coordinates)
    return coordinates if coordinates.is_a?(Array)

    coordinates = coordinates.downcase
    [
      [*'a'..'h'].find_index(coordinates[0]),
      coordinates[1].to_i - 1
    ]
  end

  def to_coord_sym(int_pair)
    return nil if out_of_bounds?(int_pair)
    return int_pair.downcase.to_sym if int_pair.is_a?(Symbol) || int_pair.is_a?(String)

    column = [*'a'..'h'][int_pair[0]]
    row = (int_pair[1] + 1).to_s
    (column + row).to_sym
  end

  def move_self(target)
    target = to_coord_sym(target)
    return nil if target.nil? || target == @coordinates

    vector = return_valid_vector(target)

    @board.destroy_piece(target) if capturing?(target)

    @coordinates = to_coord_sym(apply_vector(vector))
  end

  def apply_vector(vector, coordinates = @coordinates)
    coord_pair = to_int_pair(coordinates)
    [
      coord_pair[0] + vector[0],
      coord_pair[1] + vector[1]
    ]
  end

  def flip_vector(vector)
    vector[1] = -vector[1]
    vector
  end

  def valid_move?(target, coordinates = @coordinates)
    target = to_coord_sym(target)
    return_valid_vector(target, coordinates)
  end

  def return_valid_vector(target, coordinates = @coordinates)
    vector = find_move(target, coordinates)
    return nil if vector.nil? || piece_in_path?(target, vector, coordinates) || out_of_bounds?(target)

    vector
  end

  def find_move(target, coordinates = @coordinates)
    vector = nil
    @vectors.each do |hash|
      next unless hash[:condition].is_a?(Proc) && hash[:condition].call({ target: target, pieces: @board.pieces })

      hash.each_value do |value|
        next unless value.is_a?(Array)
        value = flip_vector(value) if @color == 'black'
        vector = value if apply_vector(value, coordinates) == to_int_pair(target)
      end
    end
    vector
  end

  def piece_in_path?(target, vector, coordinates = @coordinates)
    pointer_coord_pair = to_int_pair(coordinates)
    target_coord_pair = to_int_pair(target)
    other_pieces = @board.pieces.reject { |p| p.coordinates == coordinates }
    until pointer_coord_pair == target_coord_pair
      blocked = other_pieces.any? { |p| p.coordinates == to_coord_sym(pointer_coord_pair) }
      return true if blocked || out_of_bounds?(pointer_coord_pair)

      pointer_coord_pair = apply_vector(vector, pointer_coord_pair)
    end
    false
  end

  def out_of_bounds?(coordinates)
    coord_pair = []
    if coordinates.is_a?(Array)
      coord_pair = coordinates
    else
      coord_pair << [*'a'..'z'].find_index(coordinates[0].downcase)
      coord_pair << coordinates[1].to_i - 1
    end
    coord_pair.any? { |c| c.negative? || c > 7 }
  end

  def capturing?(target)
    @board.find_piece(to_coord_sym(target))
  end
end
