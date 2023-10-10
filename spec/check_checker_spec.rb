# frozen_string_literal: true

require './lib/game'
require './lib/board'
require './lib/piece'

describe CheckChecker do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:current_player_w) { Player.new('', 'white')}
  let(:current_player_b) { Player.new('', 'black')}
  let(:b_king) { board.find_piece(:e8) }
  let(:w_queen) { board.find_piece(:d1) }
  let(:b_pawn1) { board.find_piece(:d7) }
  let(:b_pawn2) { board.find_piece(:g7) }

  context 'valid check move' do
    before do
      remove_pieces = %i[f7 g7]
      board.pieces.reject! { |p| remove_pieces.include?(p.coordinates) }
      w_queen.move_self(:h5)
      game.previous_move = [w_queen, :h5, [3, 3]]
      game.current_player = current_player_b
    end

    it 'black king gets checked' do
      b_pawn1.move_self(:d6)
      expect(game.check?).to be_truthy
    end

    it 'black check mate' do
      game.check = true
      expect(game.check_mate?).to be_truthy
    end
  end

  context 'check resolved' do
    before do
      remove_pieces = %i[d7 f7]
      board.pieces.reject! { |p| remove_pieces.include?(p.coordinates) }
      w_queen.move_self(:h5)
      game.check = true
      game.previous_move = [w_queen, :h5, [3, 3]]
      game.current_player = current_player_b
    end

    it 'black king moves out of the way' do
      resolved = game.check_resolved?(b_king, :d7)
      expect(resolved).to be_truthy
    end

    it 'attacker is captured' do
      w_queen.move_self(:f7)
      game.previous_move = [w_queen, :f7, [-2, 2]]
      resolved = game.check_resolved?(b_king, :f7)
      expect(resolved).to be_truthy
    end

    it 'piece is blocking attacker' do
      resolved = game.check_resolved?(b_pawn2, :g6)
      expect(resolved).to be_truthy
    end
  end
end
