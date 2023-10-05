# frozen_string_literal: true

require_relative './frame'

class Game
  attr_reader :frames

  def initialize(frames)
    @frames = frames
  end

  def score
    frames.each_with_index.sum do |frame, index|
      if frame.strike?
        calculate_strike_frame(*frames[index, 3])
      elsif frame.spare?
        next_frame = frames[index + 1]
        next_frame.nil? ? frame.score : Shot::MAX_POINTS + next_frame.first_shot.score
      else
        frame.score
      end
    end
  end

  private

  def calculate_strike_frame(current_frame, next_frame = nil, next_next_frame = nil)
    return current_frame.score if next_frame.nil?

    if next_frame.strike?
      if next_next_frame.nil?
        Shot::MAX_POINTS * 2 + next_frame.second_shot.score
      else
        Shot::MAX_POINTS * 2 + next_next_frame.first_shot.score
      end
    else
      Shot::MAX_POINTS + next_frame.first_shot.score + next_frame.second_shot.score
    end
  end
end
