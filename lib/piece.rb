# frozen_string_literal: true

require_relative 'conversions'

# Generic piece
class Piece
  include Conversions

  attr_accessor :coordinates
  attr_reader :icon, :color, :board, :first_move

  def initialize(color, coordinates, board)
    @color = color
    @coordinates = coordinates
    @first_move = true
    @board = board
  end

  def valid_move?(target, coordinates = @coordinates)
    find_valid_vector(target, coordinates)
  end

  def move_self(target, vector)
    @first_move = false
    @board.destroy_piece(target) if capturing?(target)
    @coordinates = to_coord_sym(apply_vector(vector))
  end

  def apply_vector(vector, coordinates = @coordinates)
    return nil if vector.nil?

    coord_pair = to_int_pair(coordinates)
    [coord_pair[0] + vector[0], coord_pair[1] + vector[1]]
  end

  def flip_vector(vector)
    return [vector[0], -vector[1]] if vector.is_a?(Array)

    vector.map { |k, v| k == :condition ? [k, v] : [k, [v[0], -v[1]]] }.to_h
  end

  def find_valid_vector(target, coordinates = @coordinates)
    vector = find_move(target, coordinates)
    return nil if vector.nil? ||
                  piece_in_path?(to_int_pair(target), vector, to_int_pair(coordinates)) ||
                  out_of_bounds?(target) ||
                  same_color?(target)

    vector
  end

  def find_move(target, coordinates = @coordinates)
    @vectors.select { |hash| condition_met?(hash, target) }.each do |hash|
      hash.reject { |k, _| k == :condition }.each_value do |vector|
        vector = trim_vector_to_target(vector, target) unless piece_in_path?(target, vector) || is_a?(Knight)
        return vector if apply_vector(vector, coordinates) == to_int_pair(target)
      end
    end
    nil
  end

  def condition_met?(hash, target)
    hash[:condition].is_a?(Proc) ? hash[:condition].call({ target: target, caller: self }) : true
  end

  def piece_in_path?(target, vector, coordinates = @coordinates)
    return false if is_a?(Knight)

    target = to_coord_sym(target)
    coordinates = to_coord_sym(coordinates)
    other_pieces = @board.pieces.reject { |p| p.coordinates == to_coord_sym(coordinates) }
    until coordinates == target
      return false if out_of_bounds?(coordinates)

      blocked = other_pieces.any? { |p| p.coordinates == to_coord_sym(coordinates) }
      return true if blocked

      coordinates = to_coord_sym(apply_vector(minimize_vector(vector), coordinates))
      return false if coordinates == @coordinates
    end
    false
  end

  def out_of_bounds?(coordinates)
    return true if coordinates.nil?

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

  def same_color?(target)
    target_piece = @board.find_piece(to_coord_sym(target))
    return false if target_piece.nil?

    @color == target_piece.color
  end

  def trim_vector_to_target(vector, target)
    until vector == minimize_vector(vector)
      return vector if apply_vector(vector) == to_int_pair(target)

      vector = trim_vector_by_one(vector)
    end
    vector
  end
end
