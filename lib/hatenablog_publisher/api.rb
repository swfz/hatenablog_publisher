require 'oauth'
require 'json'

module HatenablogPublisher
  class Api
    attr_reader :client, :header, :site

    def initialize(site)
      @site = site

      @header = {
        'Accept' => 'application/xml',
        'Content-Type' => 'application/xml'
      }

      consumer = OAuth::Consumer.new(
        ENV['HATENABLOG_CONSUMER_KEY'],
        ENV['HATENABLOG_CONSUMER_SECRET'],
        site: site,
        timeout: 300
      )

      @client = OAuth::AccessToken.new(
        consumer,
        ENV['HATENABLOG_ACCESS_TOKEN'],
        ENV['HATENABLOG_ACCESS_TOKEN_SECRET']
      )
    end

    def request(path, body, method = :post)
      @client.request(method, path, body, @header)
    end
  end
end
