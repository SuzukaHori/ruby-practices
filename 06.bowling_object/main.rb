require_relative './game'
score = ARGV[0]

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
puts game.total
