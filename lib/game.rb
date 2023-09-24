# frozen_string_literal: true

require_relative 'board'
require_relative 'piece'
require_relative 'player'

# Manges game flow
class Game
  attr_reader :players
  attr_accessor :current_player

  def initialize
    @players = []
    @board = Board.new
  end

  def start_game
    assign_players
  end

  def assign_players
    2.times do |i|
      @players << Player.new(gets.chomp, i.zero? ? 'white' : 'black')
    end
  end
end
