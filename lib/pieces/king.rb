# frozen_string_literal: true

module Piece
  # King
  class King < Piece
    VECTORS = [
      {
        condition: nil,
        forward: [0, 1],
        backward: [0, -1],
        left: [-1, 0],
        right: [1, 0],
        forward_right: [1, 1],
        forward_left: [-1, 1],
        back_right: [1, -1],
        back_left: [-1, -1]
      },
      {
        condition: ->(options) { options[:caller].castle_valid?(options[:target]) },
        castle_left: [-2, 0],
        castle_right: [2, 0]
      }
    ].freeze

    attr_reader :vectors, :has_castled

    def initialize(color, coordinates, board)
      super
      @icon = @color == 'white' ? '♚' : '♔'
      @has_castled = false
      @vectors = VECTORS
      return unless color == 'black'

      @vectors = @vectors.map { |hash| flip_vector(hash) }
    end

    def castle_valid?(target)
      castle, direction = return_castle(target)
      return false if @has_castled || !@first_move || @board.game.check || castle.nil?

      to_castle_vector = direction == 'left' ? [-4, 0] : [3, 0]
      castle.first_move && !piece_in_path?(castle.coordinates, to_castle_vector)
    end

    def handle_castling(target, vector)
      return unless vector.any? { |v| v.abs > 1 }

      castle, = return_castle(target)
      castle_target = to_coord_sym(apply_vector(minimize_vector(vector)))
      castle.move_self(castle_target)
    end

    def return_castle(target)
      direction = target[0] < @coordinates[0] ? 'left' : 'right'
      castle = @board.find_piece("a#{@coordinates[1]}".to_sym) if direction == 'left'
      castle = @board.find_piece("h#{@coordinates[1]}".to_sym) if direction == 'right'
      [castle, direction]
    end
  end
end
