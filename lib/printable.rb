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
  end

  def print_request_piece(player)
    print "#{player.name}, which piece? -> "
  end

  def print_request_target(piece)
    print "Move #{piece.class.to_s.downcase} where? -> "
  end
end
