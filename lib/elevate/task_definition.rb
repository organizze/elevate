module Elevate
  class TaskDefinition
    def initialize(name, options, &block)
      @name = name
      @options = options
      @handlers = {}

      instance_eval(&block)
    end

    attr_reader :name
    attr_reader :handlers
    attr_reader :options

    def method_missing(method, *args, &block)
      if method.to_s.start_with?("on_")
        raise ArgumentError, "wrong number of arguments" unless args.empty?
        raise ArgumentError, "block not supplied" unless block_given?

        @handlers[method.to_sym] = block.weak!
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      method.to_s.start_with?("on_") || super
    end

    def background(&block)
      @handlers[:background] = block.weak!
    end

    def on_error(&block)
      raise "on_error blocks must accept one parameter" unless block.arity == 1

      @handlers[:on_error] = block.weak!
    end

    def on_finish(&block)
      raise "on_finish blocks must accept two parameters" unless block.arity == 2

      @handlers[:on_finish] = block.weak!
    end

    def on_start(&block)
      raise "on_start blocks must accept zero parameters" unless block.arity == 0

      @handlers[:on_start] = block.weak!
    end

    def on_update(&block)
      @handlers[:on_update] = block.weak!
    end

    def timeout(seconds)
      raise "timeout argument must be a number" unless seconds.is_a?(Numeric)

      @options[:timeout_interval] = seconds
    end
  end
end
