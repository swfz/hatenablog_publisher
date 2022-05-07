module HatenablogPublisher
  class Io
    def initialize(options)
      @options = options
    end

    def data_file?
      data_file.present?
    end

    def data_file
      @options.data_file
    end

    def yaml_loader
      FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Time])
    end

    def write(metadata, text)
      if data_file?
        write_data_file(metadata)
      else
        write_file(metadata, text)
      end
    end

    def write_data_file(metadata)
      data = JSON.parse(File.read(@options.data_file))
      data.each do |l|
        next unless l['filepath'] == @options.filename

        l.deep_symbolize_keys!.merge!(metadata)
      end
      File.write(data_file, JSON.pretty_generate(data, indent: '   ', space_before: ' '))
    end

    def write_file(metadata, text)
      filename = @options.filename
      parsed = FrontMatterParser::Parser.parse_file(filename, loader: yaml_loader)
      front_matter = parsed.front_matter.deep_symbolize_keys.merge(metadata)
      body = YAML.dump(front_matter.deep_stringify_keys) + "\n---\n\n" + text
      File.write(filename, body)
    end

    def read
      filename = @options.filename

      if data_file?
        read_from_datafile(filename)
      else
        read_from_file(filename)
      end
    end

    def read_from_datafile(filename)
      json = JSON.parse(File.read(data_file))
      target = json.find { |l| l['filepath'] == filename }

      [target.deep_symbolize_keys, File.read(filename)]
    end

    def read_from_file(filename)
      parsed = FrontMatterParser::Parser.parse_file(filename, loader: yaml_loader)

      [parsed.front_matter.deep_symbolize_keys, parsed.content]
    end
  end
end
