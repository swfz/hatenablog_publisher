require_relative 'lib/hatenablog_publisher/version'

Gem::Specification.new do |spec|
  spec.name          = "hatenablog_publisher"
  spec.version       = HatenablogPublisher::VERSION
  spec.authors       = ["swfz"]
  spec.email         = ["sawafuji.09@gmail.com"]

  spec.summary       = %q{Gem that posts to the Hatena Blog API and PhotoLife API}
  spec.homepage      = "https://github.com/swfz/hatenablog_publisher"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/swfz/hatenablog_publisher"
  spec.metadata["changelog_uri"] = "https://github.com/swfz/hatenablog_publisher"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'pry-byebug'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'front_matter_parser'
  spec.add_dependency 'oauth'
  spec.add_dependency 'mime-types'
  spec.add_dependency 'oga'
  spec.add_dependency 'sanitize'
  spec.add_dependency 'xml-simple'
end
