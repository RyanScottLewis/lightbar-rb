require 'lightbar/subscriber/base'
require 'lightbar/event/tick'

module Lightbar
  module Subscriber

    # Publishes tick events at a near-constant 60 FPS.
    class Timer < Base

      TICK_DELAY  = 1.0 / 60.0
      CHECK_DELAY = 0.01

      attr_reader :last_tick_at
      attr_reader :current_tick_at
      attr_reader :delta

      def on_init(event)
        @last_tick_at = @current_tick_at = Time.now
        @delta        = 0.0
        @running      = true

        while @running
          check_tick
          wait
        end
      end

      def on_stop(event)
        stop
      end

      def on_exit(event)
        stop
      end

      def stop
        @running = false
      end

      protected

      def check_tick
        @current_tick_at = Time.now
        @delta           = @current_tick_at - @last_tick_at

        publish_tick if @delta >= TICK_DELAY
      end

      def wait
        sleep(CHECK_DELAY)
      end

      def publish_tick
        publish(Event::Tick, self)

        @last_tick_at = @current_tick_at
      end

    end

  end
end

