require 'oga'
require 'hatenablog_publisher/request_logger'

module HatenablogPublisher
  class Entry
    include HatenablogPublisher::RequestLogger

    attr_reader :client, :context, :options

    ENDPOINT = 'https://blog.hatena.ne.jp'.freeze

    def initialize(context, options)
      @client = HatenablogPublisher::Api.new(ENDPOINT)
      @context = context
      @options = options
    end

    def post_entry(body)
      request_xml = format_request(body)
      basename = File.basename(@options.filename)

      res = with_logging_request(basename, request_xml) do
        method = @context.hatena.dig(:id) ? :put : :post
        @client.request(api_url, request_xml, method)
      end

      parse_response(res.body)
    end

    private

    def api_url
      id = @context.hatena.dig(:id) ? '/' + @context.hatena[:id] : ''
      "#{ENDPOINT}/#{@options.user}/#{@options.site}/atom/entry#{id}"
    end

    def parse_response(response_body)
      XmlSimple.xml_in(response_body)
    end

    def categories
      @context.categories.map do |c|
        '<category term="' + c + '" />'
      end.join
    end

    def format_request(body)
      draft = @options.draft ? 'yes' : 'no'
      body = <<~"XML"
        <?xml version="1.0" encoding="utf-8"?>
          <entry xmlns="http://www.w3.org/2005/Atom"
        xmlns:app="http://www.w3.org/2007/app">
        <title>#{@context.title}</title>
          <author><name>#{@options.user}</name></author>
          <content type="text/plain">
        #{body}
          </content>
          <updated>#{@context.updated}</updated>
          #{categories}
          <app:control>
            <app:draft>#{draft}</app:draft>
          </app:control>
        </entry>
      XML
      body
    end
  end
end
