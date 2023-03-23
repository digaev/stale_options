$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::SimpleFormatter,
])
SimpleCov.start

require 'stale_options'
require 'minitest/autorun'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'test/fixtures/test.sqlite3'
)

Dir["#{Dir.pwd}/test/support/**/*.rb"].each { |f| require f }
