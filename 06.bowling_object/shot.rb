# frozen_string_literal: true

class Shot
  attr_reader :mark

  MAX_POINTS = 10
  STRIKE_MARK = 'X'

  def initialize(mark)
    @mark = mark
  end

  def point
    mark == STRIKE_MARK ? MAX_POINTS : mark.to_i
  end
end
