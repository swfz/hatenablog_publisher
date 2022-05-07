require 'yaml'
require 'time'
require 'front_matter_parser'
require 'active_support'
require 'active_support/core_ext/hash'

module HatenablogPublisher
  class Context
    attr_reader :title, :categories, :updated, :text, :hatena

    def initialize(io)
      @io = io

      read_context
    end

    def reload_context
      write_context
      read_context
    end

    def add_image_context(image, tag)
      # APIのレスポンスをそのまま使用すると記事上でフォトライフへのリンクになってしまうため、管理画面から画像投稿した結果と合わせた(image -> plain)
      syntax = "[#{image['syntax'].first}]".gsub(/:image\]/,':plain]')

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
      @updated = time_to_s(entry['updated'].first)
    end

    def time_to_s(str)
      Time.parse(str).strftime('%Y-%m-%dT%H:%M:%S')
    end

    def metadata
      {
        title: @title,
        category: @categories,
        updated: @updated,
        hatena: @hatena
      }
    end

    private

    def write_context
      @io.write(metadata, @text)
    end

    def read_context
      data, text = @io.read

      updated = data[:updated].to_s.empty? ? '' : time_to_s(data[:updated])

      @text = text
      @categories = data[:category]
      @updated = updated
      @title = data[:title]
      @hatena = data[:hatena] || {}
    end
  end
end
