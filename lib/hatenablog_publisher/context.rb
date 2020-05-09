require 'yaml'
require 'front_matter_parser'
require 'active_support/core_ext/hash'

module HatenablogPublisher
  class Context
    attr_reader :filename, :title, :categories, :text, :hatena, :dirname, :basename

    def initialize(filename)
      @filename = filename
      @dirname = File.dirname(filename)
      @basename = File.basename(filename)

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
      @hatena[:image][tag.to_sym][:syntax]
    end

    def posted_image?(tag)
      @hatena.dig(:image, tag.to_sym, :syntax).present?
    end

    def add_entry_context(entry)
      @hatena ||= {}
      @hatena[:id] = entry['id'].first.split('-').last
    end

    private

    def front_matter
      {
        title: @title,
        category: @categories,
        hatena: @hatena
      }.deep_stringify_keys
    end

    def write_context
      body = YAML.dump(front_matter) + "\n---\n\n" + @text
      File.write(@filename, body)
    end

    def read_context
      parsed = FrontMatterParser::Parser.parse_file(@filename)

      @title = parsed.front_matter['title']
      @categories = parsed.front_matter['category']
      @text = parsed.content
      @hatena = if parsed.front_matter['hatena'].nil?
                  {}
                else
                  parsed.front_matter['hatena'].deep_symbolize_keys
                end
    end
  end
end
