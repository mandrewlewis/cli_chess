# frozen_string_literal: true

require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#build_empty_board' do
    before do
      board.build_empty_board
    end

    it 'has 64 unique keys in instance hash' do
      expect(board.board_state.keys.uniq.size).to eql(64)
    end

    it 'has all nil values' do
      expect(board.board_state.values).to all be_falsey
    end
  end

  describe '#place_initial_pieces' do
    let(:pieces) { board.board_state.values }

    before do
      board.build_empty_board
      board.place_initial_pieces
    end

    it 'places 32 uniq pieces' do
      expect(pieces.compact.size).to eql(32)
    end

    it 'places 16 white pieces' do
      white_pieces = pieces.select { |p| p&.color == 'white' }
      expect(white_pieces.size).to eql(16)
    end

    it 'places 16 black pieces' do
      black_pieces = pieces.select { |p| p&.color == 'black' }
      expect(black_pieces.size).to eql(16)
    end

    it 'doesn\'t place pieces in the middle four rows' do
      middle_rows = board.board_state.select { |k, _| %w[3 4 5 6].include?(k[1]) }
      expect(middle_rows.values).to all be_falsey
    end

    it 'has two kings' do
      kings = pieces.select { |p| p&.is_a?(King) }
      expect(kings.size).to eql(2)
    end
  end

  describe '#board_state_icons' do
    context 'When starting a new game' do
      before do
        board.build_empty_board
        board.place_initial_pieces
      end

      it 'returns icons eql to number of pieces still on the board' do
        pieces_left = board.board_state.values.compact
        non_empty_icons = board.board_state_icons.flatten.reject { |icon| icon == ' ' }
        expect(non_empty_icons.size).to eql(pieces_left.size)
      end
    end

    context 'When in the middle of a game' do
      let(:mid_game_board) { double('mid_game_board') }

      before do
        board.build_empty_board
        board.place_initial_pieces
        some_keys = board.board_state.keys.sample(32)
        new_state = board.board_state.map { |k, v| [k, some_keys.include?(k) ? nil : v] }.to_h
        allow(mid_game_board).to receive(:board_state).and_return(new_state)
      end

      it 'returns icons eql to number of pieces still on the board' do
        state = mid_game_board.board_state
        pieces_left = state.values.compact
        non_empty_icons = board.board_state_icons(state).flatten.reject { |icon| icon == ' ' }
        expect(non_empty_icons.size).to eql(pieces_left.size)
      end
    end
  end
end
