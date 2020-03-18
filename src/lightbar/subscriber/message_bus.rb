require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    # Controls the message bus.
    class MessageBus < Base

      def initialize(publisher, message_bus)
        super(publisher)

        @message_bus = message_bus
      end

      def on_exit(event)
        @message_bus.quit
      end

    end

  end
end

