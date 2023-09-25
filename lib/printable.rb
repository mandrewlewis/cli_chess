# frozen_string_literal: true

# Handles printing messages to terminal
module Printable
  def print_welcome
    system('clear')
    puts <<~HEREDOC
      -------------------------
        Welcome to CLI Chess!
      -------------------------
    HEREDOC
  end

  def print_request_name(index)
    color = index.zero? ? 'White' : 'Black'
    print "#{color} player name: "
    gets.chomp
  end

  def print_request_piece(player)
    print "#{player.name}, which piece? -> "
    gets.chomp
  end

  def print_request_target(piece)
    print "Move #{piece.class.to_s.downcase} where? -> "
    gets.chomp
  end

  def print_game_over
    print "Game Over!"
    sleep(5)
  end
end
