#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(",")
shots = []
scores.each do |s|
  if s == "X"
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a
frames[9].push(*frames.pop) while frames[10]

point = 0
STRIKE_POINT = 10

frames.each_with_index do |frame, index|
  next_frame = frames[index + 1]
  point +=
    if index == 9
      frame.sum
    elsif frame[0] == STRIKE_POINT
      if next_frame[0] == STRIKE_POINT
        if index == 8
          STRIKE_POINT * 2 + next_frame[2]
        else
          STRIKE_POINT * 2 + frames[index + 2][0]
        end
      else
        STRIKE_POINT + next_frame[0] + next_frame[1]
      end
    elsif frame.sum == STRIKE_POINT
      STRIKE_POINT + next_frame[0]
    else
      frame.sum
    end
end

puts point
