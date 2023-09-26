require 'minitest/autorun'
require_relative './frame'

class FrameTest < Minitest::Test
  def test_frame
    frame = Frame.new('1', '9')
    assert_equal 10, frame.score
  end

  def test_frame_strike
    frame = Frame.new('X')
    assert_equal 10, frame.score
  end

  def test_frame_spare
    frame = Frame.new('', '')
  end
end
