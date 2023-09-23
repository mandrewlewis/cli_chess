# frozen_string_literal: true

require './lib/board'
require './lib/piece'

describe Piece do
  board = Board.new
  let(:pieces) { board.pieces }
  let(:piece) { board.pieces.find { |p| p.coordinates = :a2 } }

  describe 'test' do
    it 'has 32 pieces' do
      expect(pieces.size).to eql(32)
    end

    it 'has 25 pieces mid game' do
      destroy = %i[c2 d2 e2 g7 g8 h7 h8]
      pieces_mid_game = pieces.reject { |p| destroy.include?(p.coordinates) }
      expect(pieces_mid_game.size).to eql(25)
    end
  end

  describe '#move_self' do
    it 'returns nil if invalid move' do
      pawn = pieces.find { |p| p.coordinates == :a2 && p.is_a?(Pawn) }
      return_value = pawn.move_self(:z9)
      expect(return_value).to be_falsey
    end

    it 'piece unchanged if target is itself' do
      pawn = pieces.find { |p| p.coordinates == :a2 && p.is_a?(Pawn) }
      expect { pawn.move_self(:a2) }.not_to change { pawn.coordinates }
    end

    it 'piece still in list if target is itself' do
      pawn = pieces.find { |p| p.coordinates == :a2 && p.is_a?(Pawn) }
      pawn.move_self(pawn.coordinates)
      piece_present = pieces.include?(pawn)
      expect(piece_present).to be_truthy
    end

    it 'piece changes coordinates to target value' do
      pawn = pieces.find { |p| p.coordinates == :a2 && p.is_a?(Pawn) }
      pawn.move_self(:a3)
      expect(pawn.coordinates).to eql(:a3)
    end

    it 'black piece moves in its relative direction' do
      pawn_black = pieces.find { |p| p.coordinates == :a7 && p.is_a?(Pawn) }
      pawn_black.move_self(:a6)
      expect(pawn_black.coordinates).to eql(:a6)
    end
  end

  describe '#flip_vector' do
    it '[0, 0]' do
      vector = piece.flip_vector([0, 0])
      expect(vector).to eql([0, 0])
    end

    it '[1, 1]' do
      vector = piece.flip_vector([1, 1])
      expect(vector).to eql([1, -1])
    end
  end

  describe '#piece_in_path?' do
    it 'returns false if target is self' do
      blocked = piece.piece_in_path?(piece.coordinates, [0, 0])
      expect(blocked).to be_falsey
    end

    it 'returns false if capturing, but path clear' do
      pawn = pieces.find { |p| p.coordinates == :a3 && p.is_a?(Pawn) }
      blocked = pawn.piece_in_path?(pawn.coordinates, [0, 0])
      expect(blocked).to be_falsey
    end

    it 'returns true if target out of bounds' do
      pawn = pieces.find { |p| p.coordinates == :a3 && p.is_a?(Pawn) }
      blocked = pawn.piece_in_path?(:i9, [0, 1])
      expect(blocked).to be_truthy
    end
  end

  describe '#out_of_bounds?' do
    it 'symbol :i9' do
      oob = pieces.first.out_of_bounds?(:i9)
      expect(oob).to be_truthy
    end

    it 'string Z1' do
      oob = pieces.first.out_of_bounds?('Z1')
      expect(oob).to be_truthy
    end

    it 'int_pair [9, 9]' do
      oob = pieces.first.out_of_bounds?([9, 9])
      expect(oob).to be_truthy
    end

    it 'returns false if in bounds' do
      oob = pieces.first.out_of_bounds?(:c4)
      expect(oob).to be_falsey
    end
  end

  describe '#capturing?' do
    it 'returns false if target space is unoccupied' do
      occ = pieces.first.capturing?(:z9)
      expect(occ).to be_falsey
    end

    it 'returns true if target space is occupied' do
      occ = pieces.first.capturing?(:a1)
      expect(occ).to be_truthy
    end
  end
end
