require "bundler/setup"

require 'simplecov'

SimpleCov.start do
  load_profile "test_frameworks"
  enable_coverage :branch

  if ENV['CI']
    require 'codecov'
    formatter SimpleCov::Formatter::Codecov
  else
    formatter SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::SimpleFormatter,
      SimpleCov::Formatter::HTMLFormatter
    ])
  end
end

require "hatenablog_publisher"


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
