module HatenablogPublisher
  class Options
    attr_reader :args

    def initialize(args)
      @args = args.with_indifferent_access
    end

    def draft?
      @args[:is_draft].present?
    end

    def debug?
      @args[:is_debug].present?
    end
  end
end
