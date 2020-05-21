module HatenablogPublisher
  module FixedContent
    class Ad
      MAX_AD_SIZE = 3

      def initialize(category, options)
        @mapping = YAML.load_file(options.ad_file)
        @options = options
        @category = category
      end

      def format_body
        "\n\n\n" + CGI.escapeHTML(sample_items.join("\n"))
      end

      def sample_items
        @mapping.slice(*@category).map { |_, v| v }.flatten.sample(MAX_AD_SIZE).map do |r|
          r[@options.ad_type]
        end
      end
    end
  end
end
