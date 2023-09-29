# frozen_string_literal: true

require './lib/game'
require './lib/board'
require './lib/piece'

describe Queen do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:w_queen) { board.find_piece(:d1) }
  let(:b_queen) { board.find_piece(:d8) }

  context 'valid moves' do
    before do
      remove_pieces = %i[c2 d2 e2 c7 d7 e7]
      board.pieces.reject! { |p| remove_pieces.include?(p.coordinates) }
    end

    it 'forward some (w)' do
      moved = w_queen.valid_move?(:d5)
      expect(moved).to eql([0, 4])
    end

    it 'forward and capture (w)' do
      moved = w_queen.valid_move?(:d7)
      expect(moved).to eql([0, 6])
    end

    it 'backward (w)' do
      w_queen.move_self(:d5, [0, 4])
      moved = w_queen.valid_move?(:d1)
      expect(moved).to eql([0, -4])
    end

    it 'right (w)' do
      w_queen.move_self(:d5, [0, 4])
      moved = w_queen.valid_move?(:h5)
      expect(moved).to eql([4, 0])
    end

    it 'left (w)' do
      w_queen.move_self(:d5, [0, 4])
      moved = w_queen.valid_move?(:a5)
      expect(moved).to eql([-3, 0])
    end

    it 'forward some (b)' do
      moved = b_queen.valid_move?(:d3)
      expect(moved).to eql([0, -5])
    end

    it 'forward left some (w)' do
      moved = w_queen.valid_move?(:b3)
      expect(moved).to eql([-2, 2])
    end

    it 'forward right some (w)' do
      moved = w_queen.valid_move?(:f3)
      expect(moved).to eql([2, 2])
    end

    it 'back left some (w)' do
      w_queen.move_self(:d5, [0, 4])
      moved = w_queen.valid_move?(:b3)
      expect(moved).to eql([-2, -2])
    end

    it 'back right some (w)' do
      w_queen.move_self(:d5, [0, 4])
      moved = w_queen.valid_move?(:f3)
      expect(moved).to eql([2, -2])
    end

    it 'forward left some (b)' do
      moved = b_queen.valid_move?(:a5)
      expect(moved).to eql([-3, -3])
    end
  end

  context 'invalid moves' do
    it 'can\'t move off the board' do
      moved = b_queen.valid_move?(:d9)
      expect(moved).to be_falsey
    end

    it 'can\'t capture same color piece' do
      moved = b_queen.valid_move?(:c8)
      expect(moved).to be_falsey
    end

    it 'can\'t move full distance of piece in path' do
      moved = b_queen.valid_move?(:d1)
      expect(moved).to be_falsey
    end
  end
end
