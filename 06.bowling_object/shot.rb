# frozen_string_literal: true

class Shot
  attr_reader :mark

  STRIKE_POINT = 10

  def initialize(mark)
    @mark = mark
  end

  def score
    mark == 'X' ? STRIKE_POINT : mark.to_i
  end
end
