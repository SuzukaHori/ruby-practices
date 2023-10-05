# frozen_string_literal: true

require_relative './game'

def main
  game = Game.new(ARGV[0])
  puts game.total_score
end

main if __FILE__ == $PROGRAM_NAME
