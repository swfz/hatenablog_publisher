require 'oauth'
require 'json'
require 'awesome_print'

module HatenablogPublisher
  class Client
    attr_reader :context

    IMAGE_PATTERN = /[^`]!\[.*\]\((.*)\)/.freeze

    def initialize(args)
      @options = HatenablogPublisher::Options.create(args)
      io = HatenablogPublisher::Io.new(@options)
      @context = HatenablogPublisher::Context.new(io)
    end

    def publish
      image_tags = @context.text.scan(IMAGE_PATTERN).flatten
      photolife = HatenablogPublisher::Photolife.new
      dirname = File.dirname(@options.filename)

      image_tags.each do |tag|
        next if @context.posted_image?(tag)

        image = HatenablogPublisher::Image.new(File.join(dirname, tag))
        image_hash = photolife.upload(image)
        @context.add_image_context(image_hash, tag)
        @context.reload_context
      end

      body = generate_body

      entry = HatenablogPublisher::Entry.new(@context, @options)
      entry_hash = entry.post_entry(body)
      @context.add_entry_context(entry_hash)
      @context.reload_context
    end

    def generate_body
      generator = HatenablogPublisher::Generator::Body.new(@context, @options)
      body = generator.generate

      if @options.ad_type && @options.ad_file
        category = HatenablogPublisher::FixedContent::Ad.new(@context.categories, @options)
        body += category.format_body
      end

      body
    end
  end
end
