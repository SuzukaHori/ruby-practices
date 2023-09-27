require 'minitest/autorun'
require_relative './shot'

class ShotTest < Minitest::Test
  def test_when_mark_is_X_score_should_be_10
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end

  def test_when_mark_is_integer_number_becomes_score
    shot = Shot.new('1')
    assert_equal 1, shot.score
  end
end
