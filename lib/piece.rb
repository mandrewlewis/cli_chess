# frozen_string_literal: true

require_relative 'conversions'

# Generic piece
class Piece
  include Conversions

  attr_accessor :coordinates
  attr_reader :icon, :color, :board

  def initialize(color, coordinates, board)
    @color = color
    @coordinates = coordinates
    @board = board
  end

  def valid_move?(target, coordinates = @coordinates)
    find_valid_vector(target, coordinates)
  end

  def move_self(target)
    vector = find_valid_vector(target)
    return nil if vector.nil?

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

  def find_valid_vector(target, coordinates = @coordinates)
    vector = find_move(target, coordinates)
    return nil if vector.nil? || piece_in_path?(to_int_pair(target), vector, to_int_pair(coordinates)) || out_of_bounds?(target)

    vector
  end

  def find_move(target, coordinates = @coordinates)
    @vectors.select { |hash| condition_met?(hash, target) }.each do |hash|
      hash.reject { |k, _| k == :condition }.each_value do |vector|
        vector = flip_vector(vector) if @color == 'black'
        return vector if apply_vector(vector, coordinates) == to_int_pair(target)
      end
    end
    nil
  end

  def condition_met?(hash, target)
    hash[:condition].call({ target: target, caller: self }) if hash[:condition].is_a?(Proc)
  end

  def piece_in_path?(target, vector, coordinates = @coordinates)
    other_pieces = @board.pieces.reject { |p| p.coordinates == to_coord_sym(coordinates) }
    until coordinates == target
      blocked = other_pieces.any? { |p| p.coordinates == to_coord_sym(coordinates) }
      return true if blocked || out_of_bounds?(coordinates)

      coordinates = apply_vector(vector, coordinates)
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
