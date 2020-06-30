require "bundler/setup"

require 'simplecov'
SimpleCov.command_name 'Rspec'
SimpleCov.start do
  track_files "lib/**/*.rb"
  load_profile "test_frameworks"
  enable_coverage :branch
end

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

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
