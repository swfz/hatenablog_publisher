require 'erb'
require 'yaml'
require 'ostruct'
module HatenablogPublisher
  class Options < OpenStruct
    attr_reader :args

    REQUIRE_KEYS = %i[
      consumer_key
      consumer_secret
      access_token
      access_token_secret
      user
      site
      filename
    ].freeze

    def valid_or_raise
      config_keys = to_h.keys
      unless (lacking_keys = REQUIRE_KEYS.reject { |key| config_keys.include?(key) }).empty?
        raise "Following keys are not setup. #{lacking_keys.map(&:to_s)}"
      end

      self
    end

    class << self
      def create(args)
        config_file = 'hatenablog_publisher_config.yml'
        from_file = YAML.safe_load(ERB.new(File.read(config_file)).result)
        config = new(from_file.symbolize_keys.merge(args) { |_k, o, n| n.nil? ? o : n })
        config.valid_or_raise
      end
    end
  end
end
