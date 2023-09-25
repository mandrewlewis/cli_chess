# frozen_string_literal: true

require './lib/board'
require './lib/piece'

describe Board do
  subject(:board) { described_class.new }
  Board.new

  describe '#generate_pieces' do
    let(:pieces) { board.pieces }

    it 'places 32 uniq pieces' do
      pieces = board.pieces
      expect(pieces.size).to eql(32)
    end

    it 'places 16 white pieces' do
      white_pieces = pieces.select { |p| p.color == 'white' }
      expect(white_pieces.size).to eql(16)
    end

    it 'places 16 black pieces' do
      black_pieces = pieces.select { |p| p.color == 'black' }
      expect(black_pieces.size).to eql(16)
    end

    it 'doesn\'t place pieces in the middle four rows' do
      nil_pieces = pieces.select { |p| p.coordinates == /\D[3456]/ }
      expect(nil_pieces.size).to eql(0)
    end

    it 'has two kings' do
      kings = pieces.select { |p| p.is_a?(King) }
      expect(kings.size).to eql(2)
    end
  end

  describe '#move_piece' do
    let(:piece) { board.find_piece('a2') }

    it 'should move piece to target location' do
      board.move_piece(piece, :a4, [0, 2])
      expect(piece.coordinates).to eql(:a4)
    end

    it 'should move piece when target is an array' do
      board.move_piece(piece, [0, 3], [0, 2])
      expect(piece.coordinates).to eql(:a4)
    end

    it 'should move piece when target is a string' do
      board.move_piece(piece, 'A4', [0, 2])
      expect(piece.coordinates).to eql(:a4)
    end
  end

  describe '#find_piece' do
    it 'should return the piece at the given coordinate symbol' do
      expect(board.find_piece(:d8).class).to eql(Queen)
    end

    it 'should return the piece at the given coordinate string' do
      expect(board.find_piece('e8').class).to eql(King)
    end
  end

  describe '#destroy_piece' do
    let(:pieces) { board.pieces }
    let(:piece) { board.find_piece('a2') }

    it 'removes piece from pieces' do
      board.destroy_piece(piece.coordinates)
      expect(pieces.include?(piece)).to be_falsey
    end
  end
end
