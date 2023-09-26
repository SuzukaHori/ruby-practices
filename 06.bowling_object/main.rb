require_relative './game.rb'
# score = ARGV[0]
score = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5".split(",")
  # Frame.new(first_mark, second_mark, )できる形に変換する
  frames = []

  n = 0
  while n < score.length
    if score[n] == 'X'
      frames << ['X']
      n += 1
    else
      frames << [score[n], score[n + 1]].compact
      n += 2
    end
  end
  frames[9].push(*frames.pop) while frames[10]
  game = Game.new(frames)
  p game.total
