$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start

require 'stale_options'
require 'minitest/autorun'

Dir["#{Dir.pwd}/test/support/**/*.rb"].each { |f| require f }
