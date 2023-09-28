# frozen_string_literal: true

require 'test/unit'
require_relative '../shot'

class ShotTest < Test::Unit::TestCase
  test 'ストライクの時は10点になる' do
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end

  test 'ストライク以外の時は、与えられた整数を返す' do
    shot = Shot.new('1')
    assert_equal 1, shot.score
  end
end
