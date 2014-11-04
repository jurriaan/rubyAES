require 'simplecov'
require 'pry'
require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  # add_filter '/test/'
end
require 'minitest/autorun'
require 'minitest/hell'
require 'minitest/pride'
require 'tempfile'
require 'tmpdir'
require File.expand_path('../lib/ruby-aes.rb', __dir__)

$TEST_DIR = __dir__
$ROOT_DIR = File.expand_path('..', $TEST_DIR)
$SUPPORT_DIR = File.expand_path('./support', $TEST_DIR)
