# frozen_string_literal: true

require './lib/game'
require './lib/board'
require './lib/pieces/piece'
require './lib/pieces/pawn'

describe Piece::Pawn do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:w_pawn) { board.find_piece(:b2) }
  let(:b_pawn) { board.find_piece(:g7) }

  context 'valid moves' do
    it 'forward (w)' do
      moved = w_pawn.valid_move?(:b3)
      expect(moved).to eql([0, 1])
    end

    it 'first forward (w)' do
      moved = w_pawn.valid_move?(:b4)
      expect(moved).to eql([0, 2])
    end

    it 'capture left (w)' do
      board.pieces << Piece::Pawn.new('black', :a3, board)
      moved = w_pawn.valid_move?(:a3)
      expect(moved).to eql([-1, 1])
    end

    it 'capture right (w)' do
      board.pieces << Piece::Pawn.new('black', :c3, board)
      moved = w_pawn.valid_move?(:c3)
      expect(moved).to eql([1, 1])
    end

    it 'forward (b)' do
      moved = b_pawn.valid_move?(:g6)
      expect(moved).to eql([0, -1])
    end

    it 'first forward (b)' do
      moved = b_pawn.valid_move?(:g5)
      expect(moved).to eql([0, -2])
    end

    it 'capture left (b)' do
      board.pieces << Piece::Pawn.new('white', :f6, board)
      moved = b_pawn.valid_move?(:f6)
      expect(moved).to eql([-1, -1])
    end

    it 'capture right (b)' do
      board.pieces << Piece::Pawn.new('white', :h6, board)
      moved = b_pawn.valid_move?(:h6)
      expect(moved).to eql([1, -1])
    end

    it 'en passant' do
      w_pawn.move_self(:e5)
      b_pawn2 = board.find_piece(:f7)
      b_pawn2.move_self(:f5)
      game.previous_move = [b_pawn2, :f5, [0, -2]]
      moved = w_pawn.valid_move?(:f6)
      expect(moved).to eql([1, 1])
    end

    it 'promotion' do
      board.destroy_piece(:a8)
      board.destroy_piece(:a7)
      w_pawn.move_self(:a4)
      w_pawn.move_self(:a5)
      w_pawn.move_self(:a6)
      w_pawn.move_self(:a7)
      w_pawn.move_self(:a8)
      expect(board.pieces.include?(w_pawn)).to be_falsey
    end
  end

  context 'invalid moves' do
    it 'can\'t move off the board' do
      bad_pawn = Piece::Pawn.new('white', :a8, board)
      moved = bad_pawn.valid_move?(:a9)
      expect(moved).to be_falsey
    end

    it 'can\'t capture same color piece' do
      bad_pawn1 = Piece::Pawn.new('black', :a8, board)
      moved = bad_pawn1.valid_move?(:b7)
      expect(moved).to be_falsey
    end

    it 'can\'t move forward two if not initial move' do
      bad_pawn = Piece::Pawn.new('white', :a2, board)
      bad_pawn.move_self(:a3)
      moved = bad_pawn.valid_move?(:a5)
      expect(moved).to be_falsey
    end

    it 'can\'t move diagonally if not capturing' do
      bad_pawn = Piece::Pawn.new('white', :a2, board)
      moved = bad_pawn.valid_move?(:b3)
      expect(moved).to be_falsey
    end

    it 'can\'t move forward if target is occupied' do
      bad_pawn = Piece::Pawn.new('white', :a5, board)
      bad_pawn.move_self(:a4)
      moved = bad_pawn.valid_move?(:a7)
      expect(moved).to be_falsey
    end
  end
end
