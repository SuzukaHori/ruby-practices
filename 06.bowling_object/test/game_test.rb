# frozen_string_literal: true

require 'test/unit'
require_relative '../game'

class GameTest < Test::Unit::TestCase
  def build_frames(frames)
    frames.map { |frame| Frame.new(*frame) }
  end

  # test '合計得点を単純に計算する' do
  #   frames = build_frames()
  #   game = Game.new(frames)
  #   assert_equal 139, game.total_score
  # end

  test '一回だけストライクの場合は、次のフレームの1,2投目をたす' do
    game = Game.new('X,6,1')
    assert_equal 24, game.total_score
  end

  test '2連続ストライクの場合は、次のフレームと次の次のフレームの1投目をたす' do
    game = Game.new('X,X,6,1')
    assert_equal 50, game.total_score
  end

  test '3連続ストライクの場合は、次のフレームと次の次のフレームをたす' do
    game = Game.new('X,X,X')
    assert_equal 60, game.total_score
  end

  test '最終フレームがストライクの場合、フレームの合計を足す' do
    game = Game.new('X,X,X,X,X')
    assert_equal 90, game.total_score
  end
end
