# frozen_string_literal: true

# Stores board state and actions
class Board
  def initialize
    @board_state = {}
  end

  def build_empty_board
    columns = [*'a'..'h']
    8.times do |r|
      columns.each do |c|
        @board_state["#{c}#{r + 1}".to_sym] = nil
      end
    end
    @board_state
  end

  def display_board
    system('clear')
    output_string = <<-HEREDOC
           a   b   c   d   e   f   g   h
         +---+---+---+---+---+---+---+---+
      8  |   |   |   |   |   |   |   |   |  8
         +---+---+---+---+---+---+---+---+
      7  |   |   |   |   |   |   |   |   |  7
         +---+---+---+---+---+---+---+---+
      6  |   |   |   |   |   |   |   |   |  6
         +---+---+---+---+---+---+---+---+
      5  |   |   |   |   |   |   |   |   |  5
         +---+---+---+---+---+---+---+---+
      4  |   |   |   |   |   |   |   |   |  4
         +---+---+---+---+---+---+---+---+
      3  |   |   |   |   |   |   |   |   |  3
         +---+---+---+---+---+---+---+---+
      2  |   |   |   |   |   |   |   |   |  2
         +---+---+---+---+---+---+---+---+
      1  |   |   |   |   |   |   |   |   |  1
         +---+---+---+---+---+---+---+---+
           a   b   c   d   e   f   g   h

    HEREDOC
    puts output_string
  end
end

Board.new.display_board
# p Board.new.build_board
