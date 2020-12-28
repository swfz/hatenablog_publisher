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

        replaced_markdown = remove_textlint_comment(replace_image(markdown))

        CGI.escapeHTML(replaced_markdown)
      end

      def remove_textlint_comment(markdown)
        markdown.gsub(/^<!--\s+textlint-(enable|disable).*-->\n/, '')
      end

      def replace_image(markdown)
        markdown.gsub(IMAGE_PATTERN) do |s|
          image_name = Regexp.last_match(1)

          if image_name.match('^http')
            s
          else
            "\n\n" + @context.image_syntax(image_name)
          end
        end
      end
    end
  end
end
