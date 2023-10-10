# frozen_string_literal: true

require 'test/unit'
require_relative '../frame'

class FrameTest < Test::Unit::TestCase
  test '1投目がストライクの場合、フレームは10点' do
    frame = Frame.new('X')
    assert_equal 10, frame.shots_sum
  end

  test '1投目がストライクでなければ、フレームは1~2投目を合計した得点' do
    frame = Frame.new('1', '9')
    assert_equal 10, frame.shots_sum
  end

  test '最終フレームでスペアかストライクなら、フレームは1~3投目を合計した得点' do
    frame = Frame.new('1', '9', 'X')
    assert_equal 20, frame.shots_sum
  end
end
