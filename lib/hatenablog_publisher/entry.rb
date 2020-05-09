require 'oga'

module HatenablogPublisher
  class Entry
    attr_reader :client, :context, :options

    ENDPOINT = 'http://blog.hatena.ne.jp'.freeze

    def initialize(context, options)
      @client = HatenablogPublisher::Api.new(ENDPOINT)
      @context = context
      @options = options
    end

    def post_entry(body)
      request_xml = format_request(body)
      File.write('tmp/post_entry_request.xml', Oga.parse_xml(request_xml).to_xml)
      p '[Info] Entry: start request. output log -> post_entry_request.xml'

      method = @context.hatena.dig(:id) ? :put : :post
      res = @client.request(api_url, request_xml, method)

      File.write('tmp/post_entry_response.xml', res.body)
      p '[Info] Entry: requested. output log -> post_entry_response.xml'

      parse_response(res.body)
    end

    private

    def api_url
      id = @context.hatena.dig(:id) ? '/' + @context.hatena[:id] : ''
      "#{ENDPOINT}/#{@options.args[:user]}/#{@options.args[:site]}/atom/entry#{id}"
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
      body = <<~"XML"
        <?xml version="1.0" encoding="utf-8"?>
          <entry xmlns="http://www.w3.org/2005/Atom"
        xmlns:app="http://www.w3.org/2007/app">
        <title>#{@context.title}</title>
          <author><name>#{@options.args[:user]}</name></author>
          <content type="text/plain">
        #{body}
          </content>
          <updated>#{Time.now.strftime('%Y-%m-%dT%H:%M%S')}</updated>
          #{categories}
          <app:control>
            <app:draft>#{@options.draft}</app:draft>
          </app:control>
        </entry>
      XML
      body
    end
  end
end
