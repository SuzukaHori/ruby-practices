# frozen_string_literal: true

require_relative './frame'

class Game
  attr_reader :frames

  NUMBER_OF_FRAMES = 10

  def initialize(argv)
    @frames = build_frames(argv)
  end

  def total_score
    frames.each_with_index.sum do |frame, index|
      if frame.strike?
        calculate_strike_frame(*frames[index, 3])
      elsif frame.spare?
        next_frame = frames[index + 1]
        next_frame.nil? ? frame.shots_sum : Shot::MAX_POINTS + next_frame.first_shot.point
      else
        frame.shots_sum
      end
    end
  end

  private

  def build_frames(argv)
    scores = argv.split(',')
    frames = []
    n = 0
    while n < scores.length
      if frames.size == NUMBER_OF_FRAMES - 1 && scores[n..].size == 3
        frames << Frame.new(*scores[n, 3])
        break
      elsif scores[n] == Shot::STRIKE_MARK
        frames << Frame.new(*scores[n])
        n += 1
      else
        frames << Frame.new(*scores[n, 2])
        n += 2
      end
    end
    frames
  end

  def calculate_strike_frame(current_frame, next_frame = nil, next_next_frame = nil)
    return current_frame.shots_sum if next_frame.nil?

    if next_frame.strike?
      if next_next_frame.nil?
        Shot::MAX_POINTS * 2 + next_frame.second_shot.point
      else
        Shot::MAX_POINTS * 2 + next_next_frame.first_shot.point
      end
    else
      Shot::MAX_POINTS + next_frame.first_shot.point + next_frame.second_shot.point
    end
  end
end
