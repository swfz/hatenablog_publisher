require 'xmlsimple'

module HatenablogPublisher
  class Photolife
    include HatenablogPublisher::RequestLogger

    attr_reader :client

    ENDPOINT = 'https://f.hatena.ne.jp'.freeze

    def initialize
      @client = HatenablogPublisher::Api.new(ENDPOINT)
    end

    def upload(image)
      body = format_body(image)

      res = with_logging_request(image.title, body) do
        @client.request('/atom/post', body)
      end

      parse_response(res.body)
    end

    private

    def parse_response(response_body)
      XmlSimple.xml_in(response_body)
    end

    def format_body(image, dirname = 'Hatena Blog')
      body = <<~"XML"
        <entry xmlns="http://purl.org/atom/ns#">
          <title>#{image.title}</title>
          <content mode="base64" type="#{image.mime_type}">
            #{image.content}
          </content>
          <dc:subject>#{dirname}</dc:subject>
        </entry>
      XML

      body
    end
  end
end
