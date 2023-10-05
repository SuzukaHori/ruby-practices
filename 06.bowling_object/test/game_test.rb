# frozen_string_literal: true

require 'test/unit'
require_relative '../game'

class GameTest < Test::Unit::TestCase
  test '合計得点を単純に計算する' do
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.total_score
  end

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
end
