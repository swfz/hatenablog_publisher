require 'hatenablog_publisher/version'
require 'hatenablog_publisher/client'
require 'hatenablog_publisher/entry'
require 'hatenablog_publisher/photolife'
require 'hatenablog_publisher/image'
require 'hatenablog_publisher/context'
require 'hatenablog_publisher/options'
require 'hatenablog_publisher/api'
require 'hatenablog_publisher/generator/body'
require 'hatenablog_publisher/request_logger'
require 'hatenablog_publisher/fixed_content/ad'
require 'hatenablog_publisher/io'

module HatenablogPublisher
  class Error < StandardError; end

  class << self
    def publish(args)
      HatenablogPublisher::Client.new(args).publish
    end
  end
end
