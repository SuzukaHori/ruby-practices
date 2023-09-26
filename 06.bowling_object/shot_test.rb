require 'minitest/autorun'
require_relative './shot'

class ShotTest < Minitest::Test
  def test_score_X
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end

  def test_score_other
    shot = Shot.new('1')
    assert_equal 1, shot.score
  end
end
