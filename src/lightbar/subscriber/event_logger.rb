require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    # Logs all events, except {Event::Tick}.
    class EventLogger < Base

      def initialize(publisher, options, logger)
        super(publisher)

        @options = options
        @logger  = logger
      end

      def on(event)
        @logger.debug(event.inspect) if @options.verbose && !event.is_a?(Event::Tick)
      end

    end

  end
end

