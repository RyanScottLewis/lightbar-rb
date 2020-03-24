require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    class LocalExecution < Base

      def initialize(publisher, options, logger)
        super(publisher)

        @options = options
        @logger  = logger
      end

      def on_init(event)
        return if @options.daemon

        @logger.info("Executing locally")

        publish(Event::Tween, @options.from, @options.to)
      end

    end

  end
end

