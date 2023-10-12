# frozen_string_literal: true

require './lib/game'
require './lib/board'
require './lib/pieces/piece'
require './lib/pieces/pawn'

describe Piece::Rook do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:w_rook) { board.find_piece(:a1) }
  let(:b_rook) { board.find_piece(:h8) }

  context 'valid moves' do
    before do
      remove_pieces = %i[a2 a7 h7 h1]
      board.pieces.reject! { |p| remove_pieces.include?(p.coordinates) }
    end

    it 'forward some (w)' do
      moved = w_rook.valid_move?(:a5)
      expect(moved).to eql([0, 4])
    end

    it 'forward and capture (w)' do
      moved = w_rook.valid_move?(:a8)
      expect(moved).to eql([0, 7])
    end

    it 'backward (w)' do
      w_rook.move_self(:a8)
      moved = w_rook.valid_move?(:a3)
      expect(moved).to eql([0, -5])
    end

    it 'right (w)' do
      w_rook.move_self(:a3)
      moved = w_rook.valid_move?(:h3)
      expect(moved).to eql([7, 0])
    end

    it 'left (w)' do
      w_rook.move_self(:a3)
      w_rook.move_self(:h3)
      moved = w_rook.valid_move?(:a3)
      expect(moved).to eql([-7, 0])
    end

    it 'forward some (b)' do
      moved = b_rook.valid_move?(:h5)
      expect(moved).to eql([0, -3])
    end
  end

  context 'invalid moves' do
    it 'can\'t move off the board' do
      moved = b_rook.valid_move?(:i8)
      expect(moved).to be_falsey
    end

    it 'can\'t capture same color piece' do
      moved = b_rook.valid_move?(:g8)
      expect(moved).to be_falsey
    end

    it 'can\'t move full distance of piece in path' do
      moved = b_rook.valid_move?(:h1)
      expect(moved).to be_falsey
    end
  end
end
