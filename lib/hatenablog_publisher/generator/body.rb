module HatenablogPublisher
  module Generator
    class Body
      attr_reader :context, :options

      IMAGE_PATTERN = /[^`]!\[.*\]\((.*)\)/.freeze

      def initialize(context, options)
        @context = context
        @options = options
      end

      def generate
        markdown = @context.text.dup

        replaced_markdown = replace_image(markdown)

        CGI.escapeHTML(replaced_markdown)
      end

      def replace_image(markdown)
        markdown.gsub(IMAGE_PATTERN) do
          "\n\n" + @context.image_syntax(Regexp.last_match(1))
        end
      end
    end
  end
end
