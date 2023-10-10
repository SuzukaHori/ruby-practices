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

MAX_POINTS = 10

def calculate_strike(current_frame, next_frame = nil, next_next_frame = nil)
  return current_frame.sum if next_frame.nil?

  if next_frame[0] == MAX_POINTS
    if next_next_frame.nil?
      MAX_POINTS * 2 + next_frame[2]
    else
      MAX_POINTS * 2 + next_next_frame[0]
    end
  else
    MAX_POINTS + next_frame[0] + next_frame[1]
  end
end

point =
  frames.each_with_index.sum do |frame, index|
    if frame[0] == MAX_POINTS
      calculate_strike(*frames[index, 3])
    elsif frame.first(2).sum == MAX_POINTS
      next_frame = frames[index + 1]
      next_frame.nil? ? frame.sum : MAX_POINTS + next_frame[0]
    else
      frame.sum
    end
  end

puts point
