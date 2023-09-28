# frozen_string_literal: true

require_relative './game'

def main
  score = ARGV[0]
  frames = format_score(score)
  game = Game.new(frames)
  puts game.total
end

def format_score(score)
  frames = [] # Frame.new(first_mark, second_mark, )できる形に変換する
  n = 0
  while n < score.length
    scores = score.split(',')
    if scores[n] == 'X'
      frames << ['X']
      n += 1
    else
      frames << [scores[n], scores[n + 1]].compact
      n += 2
    end
  end
  frames[9].push(*frames.pop) while frames[10]
  frames
end

main if __FILE__ == $PROGRAM_NAME
