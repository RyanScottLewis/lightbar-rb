require 'lightbar/subscriber/base'
require 'lightbar/event/stop'

module Lightbar
  module Subscriber

    # Watches for interrupt signal and sends {Event::Stop}.
    class Signal < Base

      def on_init(event)
        trap('INT') { publish(Event::Stop) }
      end

    end

  end
end

