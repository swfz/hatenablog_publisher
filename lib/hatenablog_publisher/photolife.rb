require 'xmlsimple'

module HatenablogPublisher
  ENDPOINT = 'http://f.hatena.ne.jp'.freeze

  class Photolife
    attr_reader :client

    def initialize
      @client = HatenablogPublisher::Api.new(ENDPOINT)
    end

    def upload(image)
      p "[Info] Image: uploading... #{image.filepath}"

      body = format_body(image)
      res = @client.request('/atom/post', body)
      File.write('tmp/photo_result.xml', res.body)
      p '[Info] Image: requested. output log -> photo_result.xml'

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
