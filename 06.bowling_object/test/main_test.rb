# frozen_string_literal: true

require 'test/unit'
require_relative '../main'
require 'stringio'

class MainTest < Test::Unit::TestCase
  def setup_argv_and_output(argv)
    ARGV.replace(argv)
    $stdout = StringIO.new
  end

  def teardown
    $stdout = STDOUT
  end

  test 'スペアやストライクがある' do
    setup_argv_and_output(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
    main
    assert_equal "139\n", $stdout.string
  end

  test '最終フレームで3投目を投げる' do
    setup_argv_and_output(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'])
    main
    assert_equal "144\n", $stdout.string
  end

  test '最終フレームが連続ストライク' do
    setup_argv_and_output(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'])
    main
    assert_equal "164\n", $stdout.string
  end

  test '全てストライク' do
    setup_argv_and_output(['X,X,X,X,X,X,X,X,X,X,X,X'])
    main
    assert_equal "300\n", $stdout.string
  end

  test '最終フレーム以外で連続ストライク' do
    setup_argv_and_output(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'])
    main
    assert_equal "134\n", $stdout.string
  end

  test '0とストライクのみ' do
    setup_argv_and_output(['X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'])
    main
    assert_equal "50\n", $stdout.string
  end
end
