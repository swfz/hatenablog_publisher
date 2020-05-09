module HatenablogPublisher
  module RequestLogger
    def with_logging_request(identifier, request_body, &block)
      log("#{identifier}-request", request_body)
      res = yield
      log("#{identifier}-response", res.body)

      res
    end

    def log(identifier, text)
      Dir.mkdir('tmp') unless Dir.exist?('tmp')

      classname = self.class.to_s.demodulize.downcase
      filepath = "tmp/hatenablog_publisher-#{classname}-#{identifier}.xml"
      File.write(filepath, text)
      p "[Info] #{classname}: #{identifier}. output log -> #{filepath}."
    end
  end
end
