require 'lightbar/subscriber/base'
require 'lightbar/event/change'

module Lightbar
  module Subscriber

    # Linear interpolation over a set duration.
    class Tween < Base

      def initialize(publisher, options)
        super(publisher)

        @options = options
      end

      def on_tween(event)
        setup_variables(event)
        start_timer
      end

      def on_tick(event)
        update_time(event)
        update_value
        publish_change
        stop_timer_if_needed
      end

      def on_stop(event)
        @from = @to
      end

      protected

      def setup_variables(event)
        @from     = event.from unless event.from.nil?
        @to       = event.to
        @duration = event.duration
        @time     = 0.0

        @from ||= 0.0
      end

      def start_timer
        publish(Event::Start)
      end

      def update_time(event)
        @time += event.delta
      end

      def update_value
        ratio     = @time / @duration                 # Normalize
        @value    = (1 - ratio) * @from + ratio * @to # Precise lerp
        @value    = @value ** @options.exponent
        low, high = [@from, @to].sort                 # For clamping
        @value    = @value.clamp(low, high)           # Clamp value to limits
      end

      def publish_change
        publish(Event::Change, @value)
      end

      def stop_timer_if_needed
        publish(Event::Stop) if @value == @to
      end

    end

  end
end

