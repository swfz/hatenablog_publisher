module HatenablogPublisher
  module Generator
    class Body
      attr_reader :context, :options

      def initialize(context, options)
        @context = context
        @options = options
      end

      def generate
        markdown = @context.text.dup

        markdown.gsub!(/[^`]!\[.*\]\((.*)\)/) {"\n\n" + @context.image_syntax($1)}

        CGI.escapeHTML(markdown)
      end
    end
  end
end
