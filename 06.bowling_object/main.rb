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
    if frames.size == 9 && scores[n..].size == 3 # 最終フレームに3投目を投げた場合
      frames << Frame.new(*scores[n, 3])
      n += 3
    elsif scores[n] == 'X' # TODO: Xを変更
      frames << Frame.new('X')
      n += 1
    else
      frames << Frame.new(*scores[n, 2])
      n += 2
    end
  end
  frames
end

main if __FILE__ == $PROGRAM_NAME
