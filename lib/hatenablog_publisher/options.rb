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
      key_is_set = ->(key) { config_keys.include?(key) && !to_h[key].nil? }
      unless (lacking_keys = REQUIRE_KEYS.reject { |key| key_is_set.call(key) }).empty?
        raise "Following keys are not setup. #{lacking_keys.map(&:to_s)}"
      end

      self
    end

    class << self
      def create(args)
        config_file = args[:config] || './hatenablog_publisher_config.yml'
        from_file = if File.exist?(config_file)
                      YAML.safe_load(ERB.new(File.read(config_file)).result)
                    else
                      {}
                    end
        config = new(from_file.symbolize_keys.merge(args) { |_k, o, n| n.nil? ? o : n })
        config.valid_or_raise
      end
    end
  end
end
