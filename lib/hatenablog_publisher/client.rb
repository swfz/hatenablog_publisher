require 'oauth'
require 'json'

module HatenablogPublisher
  class Client
    attr_reader :context

    def initialize(args)
      @context = HatenablogPublisher::Context.new(args[:filename])
      @options = HatenablogPublisher::Options.new(args)
    end

    def publish
      image_tags = @context.text.scan(/[^`]!\[.*\]\((.*)\)/).flatten
      photolife = HatenablogPublisher::Photolife.new

      image_tags.each do |tag|
        next if @context.posted_image?(tag)

        image = HatenablogPublisher::Image.new(File.join(@context.dirname, tag))
        image_hash = photolife.upload(image)
        @context.add_image_context(image_hash, tag)
        @context.reload_context
      end

      generator = HatenablogPublisher::Generator::Body.new(@context, @options)

      body = generator.generate

      entry = HatenablogPublisher::Entry.new(@context, @options)
      entry_hash = entry.post_entry(body)
      @context.add_entry_context(entry_hash)
      @context.reload_context
    end
  end
end
