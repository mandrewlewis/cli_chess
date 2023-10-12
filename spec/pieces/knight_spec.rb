# frozen_string_literal: true

require './lib/game'
require './lib/board'
require './lib/pieces/piece'

describe Knight do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:w_knight) { board.find_piece(:b1) }
  let(:b_knight) { board.find_piece(:g8) }

  context 'valid moves' do
    before do
      w_knight.move_self(:a3)
      w_knight.move_self(:c4)
      w_knight.move_self(:e5)
    end

    it 'forward right (w)' do
      moved = w_knight.valid_move?(:f7)
      expect(moved).to eql([1, 2])
    end

    it 'forward left (w)' do
      moved = w_knight.valid_move?(:d7)
      expect(moved).to eql([-1, 2])
    end

    it 'back right (w)' do
      moved = w_knight.valid_move?(:f3)
      expect(moved).to eql([1, -2])
    end

    it 'back left (w)' do
      moved = w_knight.valid_move?(:d3)
      expect(moved).to eql([-1, -2])
    end

    it 'right forward (w)' do
      moved = w_knight.valid_move?(:g6)
      expect(moved).to eql([2, 1])
    end

    it 'right back (w)' do
      moved = w_knight.valid_move?(:g4)
      expect(moved).to eql([2, -1])
    end

    it 'left forward (w)' do
      moved = w_knight.valid_move?(:c6)
      expect(moved).to eql([-2, 1])
    end

    it 'left back (w)' do
      moved = w_knight.valid_move?(:c4)
      expect(moved).to eql([-2, -1])
    end
  end

  context 'invalid moves' do
    it 'can\'t move off the board' do
      moved = b_knight.valid_move?(:e9)
      expect(moved).to be_falsey
    end

    it 'can\'t capture same color piece' do
      moved = b_knight.valid_move?(:e7)
      expect(moved).to be_falsey
    end
  end
end
