require 'lightbar/subscriber/base'
require 'lightbar/event/tween'
require 'lightbar/event/exit'

module Lightbar
  module Subscriber

    # Watches for interrupt signal and emits {Event::Stop}.
    class Signaller < Base

      def on_init(event)
        trap('INT') { publish(Event::Exit) }
        trap('TERM') { publish(Event::Exit) }
      end

    end

  end
end

