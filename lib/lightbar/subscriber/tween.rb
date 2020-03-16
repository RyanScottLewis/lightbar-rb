require 'lightbar/subscriber/base'
require 'lightbar/event/change'

module Lightbar
  module Subscriber

    # Linear interpolation over a set duration.
    class Tween < Base

      def on_tick(event)
        update_time(event)
        update_value
        publish_change
        publish_stop_if_needed
      end

      protected

      def update_time(event)
        @time ||= 0.0
        @time += event.delta
      end

      # "Core" of the whole application
      def update_value
        ratio     = @time / options.duration                        # Normalize
        @value    = (1 - ratio) * options.from + ratio * options.to # Precise lerp
        low, high = [options.from, options.to].sort                 # For clamping
        @value    = @value.clamp(low, high)                         # Clamp value to limits
      end

      def publish_change
        publish(Event::Change, @value)
      end

      def publish_stop_if_needed
        if @value == options.to
          publish(Event::Stop)
          unsubscribe
        end
      end

    end

  end
end

