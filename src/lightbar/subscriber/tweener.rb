require 'lightbar/subscriber/base'
require 'lightbar/event/change'

module Lightbar
  module Subscriber

    # Interpolates over a set duration and emits {Event::Change} events.
    # This runs on {Timer} tick, so it starts and stops it when necessary.
    class Tweener < Base

      def initialize(publisher, options)
        super(publisher)

        @options = options
      end

      attr_reader :value

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
        ratio     = @time / @options.duration         # Normalize
        @value    = (1 - ratio) * @from + ratio * @to # Precise lerp
        @value    = modify_value(@value)              # Curve modifier
        low, high = [@from, @to].sort                 # For clamping
        @value    = @value.clamp(low, high)           # Clamp value to limits
      end

      def publish_change
        publish(Event::Change, @value)
      end

      def stop_timer_if_needed
        return unless @time > @options.duration
        @value = @to

        publish(Event::Stop)
      end

      def modify_value(x)
        case @options.curve
        when :linear    then x
        when :quadratic then x ** 2
        when :cubic     then x ** 3
        when :sine      then ( Math.sin( (x - 0.5) * Math::PI ) / 2 ) + 0.5
        else;                x
        end
      end

    end

  end
end

