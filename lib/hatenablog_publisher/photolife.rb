require 'xmlsimple'

module HatenablogPublisher
  class Photolife
    include HatenablogPublisher::RequestLogger

    attr_reader :client

    ENDPOINT = 'http://f.hatena.ne.jp'.freeze

    def initialize
      @client = HatenablogPublisher::Api.new(ENDPOINT)
    end

    def upload(image)
      body = format_body(image)

      log("#{image.title}-request", body)

      res = @client.request('/atom/post', body)

      log("#{image.title}-response", res.body)

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
