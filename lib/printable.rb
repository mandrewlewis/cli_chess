# frozen_string_literal: true

# Handles printing messages to terminal
module Printable
  BORDER_STRING = '  +---+---+---+---+---+---+---+---+'
  COLUMNS_STRING = "    #{[*'a'..'h'].join('   ')}"

  def print_welcome
    system('clear')
    puts <<~HEREDOC
      -------------------------
        Welcome to CLI Chess!
      -------------------------
    HEREDOC
  end

  def display_board(board)
    row_count = 8

    puts COLUMNS_STRING
    icons_by_row(board).each do |row_arr|
      puts BORDER_STRING, "#{row_count} | #{row_arr.join(' | ')} | #{row_count}"
      row_count -= 1
    end
    puts BORDER_STRING, COLUMNS_STRING, ''
  end

  def icons_by_row(board)
    board.keys.map do |arr|
      arr.map do |key|
        piece = board.find_piece(key)
        piece ? piece.icon : ' '
      end
    end
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
    subclass = piece.humanized_class
    print "Move #{subclass} where? -> "
    gets.chomp
  end

  def print_flash_notice(notice)
    puts "    ➣ #{notice[1]}", ''
    puts "    ➣ #{notice[2]}", '' unless notice[2].nil?
  end

  def print_flash_error(error)
    puts "    ✖ #{error[1]}", ''
  end

  def print_game_over(player, board)
    system('clear')
    display_board(board)
    print "GAME OVER, #{player.name} wins!"
    sleep(5)
  end
end
