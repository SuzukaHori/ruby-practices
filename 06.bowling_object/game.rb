require_relative './frame'

class Game
  STRIKE_POINT = 10
  attr_reader :frames

  def initialize(frames)
    @frames = frames.map { |frame| Frame.new(*frame) }
  end

  def total
    frames.each_with_index.sum do |frame, index|
      if frame.status == 'strike'
        calculate_strike(*frames[index, 3])
      elsif frame.status == 'spare'
        next_frame = frames[index + 1]
        next_frame.nil? ? frame.score : 10 + next_frame.first_shot.score
      else
        frame.score
      end
    end
  end

  private

  def calculate_strike(current_frame, next_frame = nil, next_next_frame = nil)
    return current_frame.score if next_frame.nil?

    if next_frame.status == 'strike'
      if next_next_frame.nil?
        STRIKE_POINT * 2 + next_frame.second_shot.score
      else
        STRIKE_POINT * 2 + next_next_frame.first_shot.score
      end
    else
      STRIKE_POINT + next_frame.first_shot.score + next_frame.second_shot.score
    end
  end
end
