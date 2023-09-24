# frozen_string_literal: true

require_relative 'board'
require_relative 'piece'
require_relative 'player'
require_relative 'printable'

# Manges game flow
class Game
  include Printable

  attr_reader :players
  attr_accessor :current_player

  def initialize
    @players = []
    @board = Board.new
  end

  def start_game
    print_welcome
    assign_players
  end

  def assign_players
    2.times do |i|
      print_request_name(i)
      @players << Player.new(gets.chomp, i.zero? ? 'white' : 'black')
    end
  end
end
