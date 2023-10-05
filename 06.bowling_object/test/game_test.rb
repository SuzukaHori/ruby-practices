# frozen_string_literal: true

require 'test/unit'
require_relative '../game'

class GameTest < Test::Unit::TestCase
  def build_frames(frames)
    frames.map { |frame| Frame.new(*frame) }
  end

  test '合計得点を単純に計算する' do
    frames = build_frames([%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], ['X'], %w[9 1], %w[8 0], ['X'], %w[6 4 5]])
    game = Game.new(frames)
    assert_equal 139, game.score
  end

  test '一回だけストライクの場合は、次のフレームの1,2投目をたす' do
    game = Game.new(build_frames([['X'], %w[6 1]]))
    assert_equal 24, game.score
  end

  test '2連続ストライクの場合は、次のフレームと次の次のフレームの1投目をたす' do
    game = Game.new(build_frames([['X'], ['X'], %w[6 1]]))
    assert_equal 50, game.score
  end

  test '3連続ストライクの場合は、次のフレームと次の次のフレームをたす' do
    game = Game.new(build_frames([['X'], ['X'], ['X']]))
    assert_equal 60, game.score
  end

  test '最終フレームがストライクの場合、フレームの合計を足す' do
    game = Game.new(build_frames([['X'], ['X'], %w[X X X]]))
    assert_equal 90, game.score
  end
end
