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

STRIKE_POINT = 10

def calculate_strike(frames, index, next_frame)
  return frames[9].sum if index == 9

  if next_frame[0] == STRIKE_POINT
    if index == 8
      STRIKE_POINT * 2 + next_frame[2]
    else
      STRIKE_POINT * 2 + frames[index + 2][0]
    end
  else
    STRIKE_POINT + next_frame[0] + next_frame[1]
  end
end

point = 0

frames.each_with_index do |frame, index|
  next_frame = frames[index + 1]
  point +=
    if frame[0] == STRIKE_POINT
      calculate_strike(frames, index, next_frame)
    elsif frame.sum == STRIKE_POINT
      STRIKE_POINT + next_frame[0]
    else
      frame.sum
    end
end

puts point
