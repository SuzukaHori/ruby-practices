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

  test 'ケース1' do
    setup_argv_and_output(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
    main
    assert_equal 139, $stdout.string.chomp.to_i
  end

  test 'ケース2' do
    setup_argv_and_output(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'])
    main
    assert_equal 164, $stdout.string.chomp.to_i
  end

  test 'ケース3' do
    setup_argv_and_output(['X,X,X,X,X,X,X,X,X,X,X,X'])
    main
    assert_equal 300, $stdout.string.chomp.to_i
  end
end
