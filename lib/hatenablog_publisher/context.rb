require 'yaml'
require 'front_matter_parser'
require 'active_support/core_ext/hash'

module HatenablogPublisher
  class Context
    attr_reader :title, :categories, :text, :hatena

    def initialize(io)
      @io = io

      read_context
    end

    def reload_context
      write_context
      read_context
    end

    def add_image_context(image, tag)
      syntax = "[#{image['syntax'].first}]"

      @hatena ||= {}
      @hatena[:image] ||= {}
      @hatena[:image][tag.to_sym] = {
        syntax: syntax,
        id: image['id'].first,
        image_url: image['imageurl'].first
      }
    end

    def image_syntax(tag)
      @hatena.dig(:image, tag.to_sym, :syntax)
    end

    def posted_image?(tag)
      image_syntax(tag).present?
    end

    def add_entry_context(entry)
      @hatena ||= {}
      @hatena[:id] = entry['id'].first.split('-').last
    end

    private

    def write_context
      @io.write(title: @title, category: @categories, hatena: @hatena, text: @text)
    end

    def read_context
      data, text = @io.read

      @text = text
      @categories = data[:category]
      @title = data[:title]
      @hatena = data[:hatena] || {}
    end
  end
end
