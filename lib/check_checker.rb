# frozen_string_literal: true

# Handles check and checkmate verification
module CheckChecker
  @state = []

  def check?
    king = @board.pieces.find { |p| p.is_a?(King) && p.color == @current_player.color }
    @previous_move[0].valid_move?(king.coordinates)
  end

  def check_mate?
    player_pieces = board.pieces.select { |p| p.color == @current_player.color }
    player_pieces.each do |p|
      valid_moves = @board.keys.flatten.select { |k| p.valid_move?(k) }
      valid_moves.each { |vm| return false if check_resolved?(p, vm) }
    end
    true
  end

  def move_will_put_player_into_check?(target, player_color)
    create_temp_board_state(target)
    player_color = 'white' if player_color.nil?
    result = king_under_attack?(player_color)
    restore_state
    result
  end

  def king_under_attack?(player_color)
    king = @board.pieces.find { |p| p.is_a?(King) && p.color == player_color }
    opp_pieces = @board.pieces.reject { |p| p.color == player_color }
    opp_pieces.each { |opp| return true if opp.can_attack_king?(king.coordinates, opp.coordinates) }
    false
  end

  def can_attack_king?(target, coordinates)
    vector = find_move(target, coordinates)
    return nil if vector.nil? ||
                  piece_in_path?(to_int_pair(target), vector, coordinates) ||
                  out_of_bounds?(target) ||
                  same_color?(target)

    vector
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

  def create_temp_board_state(target)
    store_state
    @board.destroy_piece(target) if capturing?(target)
    @coordinates = target
  end

  def store_state
    @state = [@board.pieces, @coordinates]
  end

  def restore_state
    @board.pieces, @coordinates = @state
  end
end
