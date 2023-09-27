# frozen_string_literal: true

require './lib/game'
require './lib/board'
require './lib/piece'

describe Conversions do
  game = Game.new
  board = game.board
  let(:pieces) { board.pieces }
  let(:piece) { board.pieces.find { |p| p.coordinates = :a2 } }

  describe '#to_int_pair' do
    it 'returns int pair of current coords when no params' do
      int_pair = piece.to_int_pair
      expect(int_pair).to eql([0, 1])
    end

    it 'returns same if int pair' do
      input = [1, 1]
      int_pair = piece.to_int_pair(input)
      expect(int_pair).to eql(input)
    end

    it 'returns int pair if string' do
      input = 'B2'
      int_pair = piece.to_int_pair(input)
      expect(int_pair).to eql([1, 1])
    end

    it 'returns int pair if symbol' do
      input = :b2
      int_pair = piece.to_int_pair(input)
      expect(int_pair).to eql([1, 1])
    end

    it 'returns nil when out of bounds' do
      input = :k9
      int_pair = piece.to_int_pair(input)
      expect(int_pair).to be_falsey
    end
  end

  describe '#to_coord_sym' do
    it 'returns same if sym' do
      input = :b2
      sym = piece.to_coord_sym(input)
      expect(sym).to eql(input)
    end

    it 'returns sym if string' do
      input = 'B2'
      sym = piece.to_coord_sym(input)
      expect(sym).to eql(:b2)
    end

    it 'returns sym if int pair' do
      input = [1, 1]
      sym = piece.to_coord_sym(input)
      expect(sym).to eql(:b2)
    end

    it 'returns nil when out of bounds' do
      input = [11, 11]
      sym = piece.to_coord_sym(input)
      expect(sym).to be_falsey
    end
  end
end
