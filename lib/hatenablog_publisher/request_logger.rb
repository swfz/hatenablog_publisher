require 'pry'
module HatenablogPublisher
  module RequestLogger
    def log(identifier, target)
      Dir.mkdir('tmp') if !Dir.exist?('tmp')

      classname = self.class.to_s.demodulize.downcase
      filepath = "tmp/hatenablog_publisher-#{classname}-#{identifier}.xml"
      File.write(filepath, target)
      p "[Info] #{classname}: #{identifier}. output log -> #{filepath}."
    end
  end
end
