module HatenablogPublisher
  module FixedContent
    class Ad
      def initialize(category, options)
        @mapping = YAML.load_file(options.args[:ad_file])
        @options = options
        @category = category
      end

      def format_body
        "\n\n\n" + CGI.escapeHTML(sample_items.join("\n"))
      end

      def sample_items
        @mapping.slice(*@category).map { |_, v| v }.flatten.sample(3).map do |r|
          r[@options.args[:ad_type]]
        end
      end
    end
  end
end
