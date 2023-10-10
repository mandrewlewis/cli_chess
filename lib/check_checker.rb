# frozen_string_literal: true

# Handles check and checkmate verification
module CheckChecker
  def check?
    king = @board.pieces.find { |p| p.is_a?(King) && p.color == @current_player.color }
    @previous_move[0].valid_move?(king.coordinates)
  end

  def check_resolved?(piece, target)
    king = @board.pieces.find { |p| p.is_a?(King) && p.color == @current_player.color }
    king_moved_out_of_check?(piece, target, king) ||
      captured_attacker?(piece, target) ||
      piece_in_path_to_king?(piece, target, king)
  end

  def king_moved_out_of_check?(piece, target, king)
    return false unless piece == king

    opp_pieces = board.pieces.reject { |p| p.color == @current_player.color }
    opp_pieces.each { |opp| return false if opp.valid_move?(target) }
    true
  end

  def captured_attacker?(piece, target)
    piece.capturing?(target) == @previous_move[0]
  end

  def piece_in_path_to_king?(piece, target, king)
    prev_coord = piece.coordinates
    piece.coordinates = target
    blocked = !@previous_move[0].valid_move?(king.coordinates)
    piece.coordinates = prev_coord
    blocked
  end

  def check_mate?
    player_pieces = board.pieces.select { |p| p.color == @current_player.color }
    player_pieces.each do |p|
      valid_moves = @board.keys.flatten.select { |k| p.valid_move?(k) }
      valid_moves.each { |vm| return false if check_resolved?(p, vm) }
    end
    true
  end
end
