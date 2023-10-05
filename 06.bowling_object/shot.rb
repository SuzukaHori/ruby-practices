# frozen_string_literal: true

class Shot
  attr_reader :mark

  MAX_POINTS = 10

  def initialize(mark)
    @mark = mark
  end

  def score
    mark == 'X' ? MAX_POINTS : mark.to_i
  end
end
