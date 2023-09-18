# frozen_string_literal: true

require_relative 'board'
require_relative 'piece'

# Manges game flow
class Game
  def initialize
    true
  end

  def setup_game
    @board = Board.new
  end
end
