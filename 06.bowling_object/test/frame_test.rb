# frozen_string_literal: true

require 'test/unit'
require_relative '../frame.rb'

class FrameTest < Test::Unit::TestCase
  test '1投目がストライクの場合、フレームは10点' do
    frame = Frame.new('X')
    assert_equal 10, frame.score
  end

  test '1投目がストライクでなければ、通常通り2投投げる' do
    frame = Frame.new('1', '9')
    assert_equal 10, frame.score
  end

  test '最終フレームでスペアストライクなら、3投目を投げられる' do
    frame = Frame.new('1', '9', 'X')
    assert_equal 20, frame.score
  end
end
