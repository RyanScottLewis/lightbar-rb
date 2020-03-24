require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    # Emits {Event::Tween} on RetroArch status changes from/to `playing`.
    # Fades out on starting to play and fades in on paused/stopping.
    class RetroarchTweener < Base

      def initialize(publisher, tween)
        super(publisher)

        @tween      = tween
        @last_value = 1
      end

      def on_status_change(event)
        if event.to == :playing
          @last_value = @tween.value || 0

          publish(Event::Tween, nil, 0)
        elsif event.from == :playing
          publish(Event::Tween, nil, @last_value)
        end
      end

    end

  end
end

