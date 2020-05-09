module HatenablogPublisher
  class Options
    attr_reader :args

    def initialize(args)
      @args = args.with_indifferent_access
    end

    def draft
      @args[:draft] ? 'yes' : 'no'
    end

    def debug?
      @args[:debug]
    end
  end
end
