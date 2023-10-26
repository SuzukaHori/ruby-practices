# frozen_string_literal: true

require 'test/unit'
require_relative '../main'
require 'stringio'

class MainTest < Test::Unit::TestCase
  def setup_argv_and_output(argv)
    ARGV.replace(argv)
    $stdout = StringIO.new
  end

  PATH = File.expand_path('./sample/', File.dirname(__FILE__))

  test 'オプションなしの場合は、ファイル名を表示する' do
    setup_argv_and_output([PATH])
    text = <<~LIST
      buzz.rb      sample1.text#{' '}
      fuzz.txt     sample2.rb#{'   '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'rオプションがある場合、ファイルの並びを逆にする' do
    setup_argv_and_output(['-r', PATH])
    text = <<~LIST
      sample2.rb   fuzz.txt#{'     '}
      sample1.text buzz.rb#{'      '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'aオプションがある場合、隠しファイルも表示する' do
    setup_argv_and_output(['-a', PATH])
    text = <<~LIST
      .            buzz.rb      sample1.text#{' '}
      .sample3.txt fuzz.txt     sample2.rb#{'   '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'lオプションがある場合、ファイルの詳細を表示する' do
    setup_argv_and_output(['-l', PATH])
    text = <<~LIST
      total 32
      -rw-r--r--  1 suzuka  staff  29 10 16 14:43 buzz.rb#{'      '}
      -rw-r--r--  1 suzuka  staff   5 10 16 14:05 fuzz.txt#{'     '}
      -rw-r--r--  1 suzuka  staff  35 10 16 14:05 sample1.text#{' '}
      -rw-r--r--  1 suzuka  staff  32 10 16 14:42 sample2.rb#{'   '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'aとlの2つのオプションを使った場合、すべてのファイルの詳細を表示する' do
    setup_argv_and_output(['-al', PATH])
    text = <<~LIST
      total 32
      drwxr-xr-x  7 suzuka  staff  224 10 16 14:20 .#{'            '}
      -rw-r--r--  1 suzuka  staff    0 10 16 14:20 .sample3.txt#{' '}
      -rw-r--r--  1 suzuka  staff   29 10 16 14:43 buzz.rb#{'      '}
      -rw-r--r--  1 suzuka  staff    5 10 16 14:05 fuzz.txt#{'     '}
      -rw-r--r--  1 suzuka  staff   35 10 16 14:05 sample1.text#{' '}
      -rw-r--r--  1 suzuka  staff   32 10 16 14:42 sample2.rb#{'   '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'すべてのオプションを同時に使った場合' do
    setup_argv_and_output(['-lar', PATH])
    text = <<~LIST
      total 32
      -rw-r--r--  1 suzuka  staff   32 10 16 14:42 sample2.rb#{'   '}
      -rw-r--r--  1 suzuka  staff   35 10 16 14:05 sample1.text#{' '}
      -rw-r--r--  1 suzuka  staff    5 10 16 14:05 fuzz.txt#{'     '}
      -rw-r--r--  1 suzuka  staff   29 10 16 14:43 buzz.rb#{'      '}
      -rw-r--r--  1 suzuka  staff    0 10 16 14:20 .sample3.txt#{' '}
      drwxr-xr-x  7 suzuka  staff  224 10 16 14:20 .#{'            '}
    LIST
    main
    assert_equal text, $stdout.string
  end
end
