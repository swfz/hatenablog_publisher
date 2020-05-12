module HatenablogPublisher
  class Io
    def initialize(options)
      @options = options
    end

    def data_file?
      data_file.present?
    end

    def data_file
      @options.args[:data_file]
    end

    def write(title:, category:, hatena:, text:)
      if data_file?
        write_data_file(title: title, category: category, hatena: hatena)
      else
        write_file(title: title, category: category, hatena: hatena, text: text)
      end
    end

    def write_data_file(title:, category:, hatena:)
      data = JSON.parse(File.read(@options.args[:data_file]))
      data.each do |l|
        next if l['filepath'] == @options.args[:filename]

        l.merge!(
          title: title,
          category: category,
          hatena: hatena
        )
      end
      File.write(JSON.dump(data), data_file)
    end

    def write_file(title:, category:, hatena:, text:)
      filename = @options.args[:filename]
      parsed = FrontMatterParser::Parser.parse_file(filename)
      front_matter = parsed.front_matter.deep_symbolize_keys.merge(
        title: title,
        category: category,
        hatena: hatena
      )
      body = YAML.dump(front_matter.deep_stringify_keys) + "\n---\n\n" + text
      File.write(filename, body)
    end

    def read
      filename = @options.args[:filename]

      if data_file?
        json = JSON.parse(File.read(data_file))
        target = json.find { |l| l['filepath'] == filename }

        [target.deep_symbolize_keys, File.read(filename)]
      else
        parsed = FrontMatterParser::Parser.parse_file(filename)

        [parsed.front_matter.deep_symbolize_keys, parsed.content]
      end
    end
  end
end
