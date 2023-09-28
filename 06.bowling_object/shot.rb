# frozen_string_literal: true

class Shot
  attr_reader :mark

  STRIKE_POINT = 10

  def initialize(mark)
    @mark = mark
  end

  def score
    return STRIKE_POINT if mark == 'X'

    mark.to_i
  end
end
