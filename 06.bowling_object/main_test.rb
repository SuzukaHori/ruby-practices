require 'minitest/autorun'
require_relative './main'

class MainTest < Minitest::Test
  def test_case_one
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
    $stdout = StringIO.new
    main

    assert_equal 139, $stdout.string.chomp.to_i
  end

  def test_case_two
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'])
    $stdout = StringIO.new
    main

    assert_equal 164, $stdout.string.chomp.to_i
  end

  def test_case_three
    ARGV.replace(['X,X,X,X,X,X,X,X,X,X,X,X'])
    $stdout = StringIO.new
    main

    assert_equal 300, $stdout.string.chomp.to_i
  end
end
