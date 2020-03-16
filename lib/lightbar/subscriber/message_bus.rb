require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    # Controls the message bus.
    class MessageBus < Base

      def on_exit(event)
        message_bus.quit
      end

    end

  end
end

