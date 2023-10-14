# frozen_string_literal: true

require 'test/unit'
require_relative '../main'
require 'stringio'

class MainTest < Test::Unit::TestCase
  def setup_argv_and_output(argv)
    ARGV.replace(argv)
    $stdout = StringIO.new
  end

  test 'オプションなしの場合は、ファイル名を表示する' do
    path = File.expand_path('..', File.dirname(__FILE__))
    setup_argv_and_output([path])
    text = <<~LIST
      file_info.rb    main.rb         test#{'           '}
      list_command.rb permission.rb#{'   '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'rオプションがある場合、ファイルの並びを逆にする' do
    path = File.expand_path('..', File.dirname(__FILE__))
    setup_argv_and_output(['-r', path])
    text = <<~LIST
      test            main.rb         file_info.rb#{'   '}
      permission.rb   list_command.rb#{' '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'aオプションがある場合、隠しファイルも表示する' do
    path = File.expand_path('..', File.dirname(__FILE__))
    setup_argv_and_output(['-a', path])
    text = <<~LIST
      .               list_command.rb test#{'           '}
      .gitkeep        main.rb#{'         '}
      file_info.rb    permission.rb#{'   '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'lオプションがある場合、ファイルの詳細を表示する' do
    path = File.expand_path('..', File.dirname(__FILE__))
    setup_argv_and_output(['-l', path])
    text = <<~LIST
      total 32
      -rw-r--r--  1 suzuka  staff  1152 10 14 21:18 file_info.rb#{'   '}
      -rw-r--r--  1 suzuka  staff  1118 10 14 21:28 list_command.rb
      -rwxr-xr-x  1 suzuka  staff   979 10 14 21:44 main.rb#{'        '}
      -rw-r--r--  1 suzuka  staff   828 10 14 16:20 permission.rb#{'  '}
      drwxr-xr-x  3 suzuka  staff    96 10 14 18:05 test#{'           '}
    LIST
    main
    assert_equal text, $stdout.string
  end

  test 'すべてのオプションを同時に使った場合' do
    path = File.expand_path('..', File.dirname(__FILE__))
    setup_argv_and_output(['-lar', path])
    text = <<~LIST
      total 32
      drwxr-xr-x  3 suzuka  staff    96 10 14 18:05 test#{'           '}
      -rw-r--r--  1 suzuka  staff   828 10 14 16:20 permission.rb#{'  '}
      -rwxr-xr-x  1 suzuka  staff   979 10 14 21:44 main.rb#{'        '}
      -rw-r--r--  1 suzuka  staff  1118 10 14 21:28 list_command.rb
      -rw-r--r--  1 suzuka  staff  1152 10 14 21:18 file_info.rb#{'   '}
      -rw-r--r--  1 suzuka  staff     0  4 25 15:29 .gitkeep#{'       '}
      drwxr-xr-x  8 suzuka  staff   256 10 14 17:58 .#{'              '}
    LIST
    main
    assert_equal text, $stdout.string
  end
end
