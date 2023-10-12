# frozen_string_literal: true

require_relative '../conversions'
require_relative '../check_checker'

# Generic piece
class Piece
  include Conversions
  include CheckChecker

  attr_accessor :coordinates
  attr_reader :icon, :color, :board, :first_move

  def initialize(color, coordinates, board)
    @color = color
    @coordinates = coordinates
    @first_move = true
    @board = board
  end

  def move_self(target)
    @first_move = false
    @board.destroy_piece(target) if capturing?(target)
    @coordinates = target
  end

  def valid_move?(target, coordinates = @coordinates, player_selected = nil)
    valid_vector?(target, coordinates, player_selected)
  end

  def capturing?(target)
    @board.find_piece(to_coord_sym(target))
  end

  def out_of_bounds?(coordinates)
    coord_pair = to_int_pair(coordinates) unless coordinates.nil?
    return true if coord_pair.nil?

    coord_pair.any? { |c| c.negative? || c > 7 }
  end

  def piece_in_path?(target, vector, coordinates = @coordinates)
    until coordinates == to_coord_sym(target)
      return false if out_of_bounds?(coordinates) || is_a?(Knight)

      if coordinates != @coordinates
        blocked = @board.find_piece(coordinates)
        return true if blocked
      end

      coordinates = to_coord_sym(apply_vector(minimize_vector(vector), coordinates))
      return false if coordinates == @coordinates
    end
    false
  end

  private

  def valid_vector?(target, coordinates, player_selected = nil)
    vector = find_move(target, coordinates)
    return nil if vector.nil? ||
                  piece_in_path?(to_int_pair(target), vector, coordinates) ||
                  out_of_bounds?(target) ||
                  same_color?(target) ||
                  move_will_put_player_into_check?(target, @board.game.current_player&.color, player_selected)

    vector
  end

  def find_move(target, coordinates)
    valid_vectors_only(@vectors, target).each do |vector|
      vector = trim_vector_to_target(vector, target) unless piece_in_path?(target, vector) || is_a?(Knight)
      return vector if apply_vector(vector, coordinates) == to_int_pair(target)
    end
    nil
  end

  def apply_vector(vector, coordinates = @coordinates)
    return nil if vector.nil?

    coord_pair = to_int_pair(coordinates)
    [coord_pair[0] + vector[0], coord_pair[1] + vector[1]]
  end

  def condition_met?(hash, target)
    hash[:condition].is_a?(Proc) ? hash[:condition].call({ target: target, caller: self }) : true
  end

  def same_color?(target)
    target_piece = @board.find_piece(to_coord_sym(target))
    return false if target_piece.nil?

    @color == target_piece.color
  end
end
