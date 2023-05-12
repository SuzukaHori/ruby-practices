#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a
frames[9].push(*frames.pop) while frames[10]

STRIKE_POINT = 10

def calculate_strike(current_frame, next_frame = nil, next_next_frame = nil)
  return current_frame.sum if next_frame.nil?

  if next_frame[0] == STRIKE_POINT
    if next_next_frame.nil?
      STRIKE_POINT * 2 + next_frame[2]
    else
      STRIKE_POINT * 2 + next_next_frame[0]
    end
  else
    STRIKE_POINT + next_frame[0] + next_frame[1]
  end
end

point =
  frames.each_with_index.sum do |frame, index|
    next_frame = frames[index + 1]
    if frame[0] == STRIKE_POINT
      calculate_strike(*frames[index, 3])
    elsif frame.first(2).sum == STRIKE_POINT
      next_frame.nil? ? frame.sum : STRIKE_POINT + next_frame[0]
    else
      frame.sum
    end
  end

puts point
