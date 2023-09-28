# frozen_string_literal: true

require_relative './game'

def main
  score = ARGV[0]
  frames = separate_into_frames(score.split(','))
  game = Game.new(frames)
  puts game.total
end

def separate_into_frames(scores)
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
