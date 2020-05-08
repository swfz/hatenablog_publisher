require 'base64'
require 'mime/types'

module HatenablogPublisher
  class Image
    attr_reader :filepath

    def initialize(filepath)
      @filepath = filepath
    end

    def mime_type
      MIME::Types.type_for(@filepath).first
    end

    def content
      Base64.encode64(File.read(@filepath))
    end

    def title
      File.basename(@filepath, '.*')
    end
  end
end
