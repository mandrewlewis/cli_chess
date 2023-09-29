# frozen_string_literal: true

require './lib/game'
require './lib/board'
require './lib/piece'

describe Bishop do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:w_bishop) { board.find_piece(:c1) }
  let(:b_bishop) { board.find_piece(:f8) }

  context 'valid moves' do
    before do
      remove_pieces = %i[b2 e7]
      board.pieces.reject! { |p| remove_pieces.include?(p.coordinates) }
    end

    it 'forward left some (w)' do
      moved = w_bishop.valid_move?(:a3)
      expect(moved).to eql([-2, 2])
    end

    it 'forward right some (w)' do
      w_bishop.move_self(:a3, [-2, 2])
      moved = w_bishop.valid_move?(:c5)
      expect(moved).to eql([2, 2])
    end

    it 'back left some (w)' do
      w_bishop.move_self(:a3, [-2, 2])
      w_bishop.move_self(:c5, [2, 2])
      moved = w_bishop.valid_move?(:a3)
      expect(moved).to eql([-2, -2])
    end

    it 'back left some (w)' do
      w_bishop.move_self(:a3, [-2, 2])
      w_bishop.move_self(:c5, [2, 2])
      w_bishop.move_self(:c5, [-2, -2])
      moved = w_bishop.valid_move?(:c1)
      expect(moved).to eql([2, -2])
    end

    it 'forward left some (b)' do
      moved = b_bishop.valid_move?(:d6)
      expect(moved).to eql([-2, -2])
    end
  end

  context 'invalid moves' do
    it 'can\'t move off the board' do
      moved = b_bishop.valid_move?(:g9)
      expect(moved).to be_falsey
    end

    it 'can\'t capture same color piece' do
      moved = b_bishop.valid_move?(:g7)
      expect(moved).to be_falsey
    end

    it 'can\'t move full distance of piece in path' do
      moved = b_bishop.valid_move?(:h6)
      expect(moved).to be_falsey
    end
  end
end
