require 'minitest/autorun'
require_relative './game'

class GameTest < Minitest::Test
  def test_total
    game = Game.new([%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], ['X'], %w[9 1], %w[8 0], ['X'], %w[6 4 5]])
    assert_equal 139, game.total

    game = Game.new([%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], ['X'], %w[9 1], %w[8 0], ['X'], %w[X X X]])
    assert_equal 164, game.total

    game = Game.new([['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], %w[X X X]])
    assert_equal 300, game.total
  end

  def test_calculate_one_strike # ストライクの場合は、次のフレームの1,2投目をたす
    game = Game.new([['X'], %w[6 1]])
    assert_equal 24, game.total
  end

  def test_calculate_two_strike # 2連続ストライクの場合は、次のフレームと次の次のフレームの1投目をたす
    game = Game.new([['X'], ['X'], %w[6 1]])
    assert_equal 50, game.total
  end

  def test_calculate_three_strike # 3連続ストライクの場合は、次のフレームと次の次のフレームを足す
    game = Game.new([['X'], ['X'], ['X']])
    assert_equal 60, game.total
  end

  def test_last_frame_strike
    game = Game.new([['X'], ['X'], %w[X X X]]) # 最終フレームがストライクの場合、フレームの合計を足す
    assert_equal 90, game.total
  end
end
