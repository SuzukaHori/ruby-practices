# frozen_string_literal: true

require_relative './game'

def main
  frames = parse_frames(ARGV[0])
  game = Game.new(frames)
  puts game.score
end

def parse_frames(argv)
  scores = argv.split(',')
  frames = []
  n = 0
  while n < scores.length
    if scores[n] == 'X'
      frames << ['X']
      n += 1
    else
      frames << scores[n, 2]
      n += 2
    end
  end
  frames[9].push(*frames.pop) while frames[10]
  frames
end

main if __FILE__ == $PROGRAM_NAME
