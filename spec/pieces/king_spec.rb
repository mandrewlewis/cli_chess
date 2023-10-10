# frozen_string_literal: true

require './lib/game'
require './lib/board'
require './lib/piece'

describe King do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:w_king) { board.find_piece(:e1) }
  let(:b_king) { board.find_piece(:e8) }

  context 'valid moves' do
    before do
      remove_pieces = %i[b8 c8 d8 f8 g8 b1 c1 d1 f1 g1 e2 d2 f2]
      board.pieces.reject! { |p| remove_pieces.include?(p.coordinates) }
    end

    it 'forward (w)' do
      moved = w_king.valid_move?(:e2)
      expect(moved).to eql([0, 1])
    end

    it 'forward and capture (w)' do
      b_pawn = board.find_piece(:e7)
      b_pawn.move_self(:e5)
      w_king.move_self(:e4)
      moved = w_king.valid_move?(:e5)
      expect(moved).to eql([0, 1])
    end

    it 'backward (w)' do
      w_king.move_self(:e2)
      moved = w_king.valid_move?(:e1)
      expect(moved).to eql([0, -1])
    end

    it 'right (w)' do
      w_king.move_self(:e2)
      w_king.move_self(:e3)
      moved = w_king.valid_move?(:f3)
      expect(moved).to eql([1, 0])
    end

    it 'left (w)' do
      w_king.move_self(:e2)
      w_king.move_self(:e3)
      moved = w_king.valid_move?(:d3)
      expect(moved).to eql([-1, 0])
    end

    it 'forward left (w)' do
      moved = w_king.valid_move?(:d2)
      expect(moved).to eql([-1, 1])
    end

    it 'forward right (w)' do
      moved = w_king.valid_move?(:f2)
      expect(moved).to eql([1, 1])
    end

    it 'back left (w)' do
      w_king.move_self(:f2)
      moved = w_king.valid_move?(:e1)
      expect(moved).to eql([-1, -1])
    end

    it 'back right (w)' do
      w_king.move_self(:d2)
      moved = w_king.valid_move?(:e1)
      expect(moved).to eql([1, -1])
    end

    it 'castle left (w)' do
      moved = w_king.valid_move?(:c1)
      expect(moved).to eql([-2, 0])
    end

    it 'castle right (b)' do
      moved = b_king.valid_move?(:g8)
      expect(moved).to eql([2, 0])
    end
  end

  context 'invalid moves' do
    it 'can\'t move off the board' do
      moved = b_king.valid_move?(:e9)
      expect(moved).to be_falsey
    end

    it 'can\'t capture same color piece' do
      moved = b_king.valid_move?(:e7)
      expect(moved).to be_falsey
    end

    it 'can\'t castle if rook moved' do
      board.find_piece(:a1).move_self(:b1)
      moved = w_king.valid_move?(:c1)
      expect(moved).to be_falsey
    end

    it 'can\'t castle if king moved' do
      b_king.move_self(:d8)
      b_king.move_self(:e8)
      moved = b_king.valid_move?(:c8)
      expect(moved).to be_falsey
    end
  end
end
