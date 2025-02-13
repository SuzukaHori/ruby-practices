# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def shots_sum
    first_shot.point + second_shot.point + third_shot.point
  end

  def strike?
    first_shot.point == Shot::MAX_POINTS
  end

  def spare?
    first_shot.point + second_shot.point == Shot::MAX_POINTS
  end
end
