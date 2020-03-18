require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    # Logs all events.
    class EventLogger < Base

      def initialize(publisher, options)
        super(publisher)

        @options = options
      end

      def on(event)
        puts(event.inspect) if @options.verbose && !event.is_a?(Event::Tick)
        #logger.debug(event.inspect) if @options.verbose && !event.is_a?(Event::Tick)
      end

    end

  end
end

