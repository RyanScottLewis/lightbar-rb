require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    # Emits {Event::Tween} on {Event::Initialize} and {Event::Exit} events.
    class EpochTweener < Base

      def on_init(event)
        publish(Event::Tween, 0, 1)
      end

      def on_exit(event)
        publish(Event::Tween, nil, 0)
      end

    end

  end
end

