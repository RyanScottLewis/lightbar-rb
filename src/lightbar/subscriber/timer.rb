require 'lightbar/subscriber/base'
require 'lightbar/event/tick'

module Lightbar
  module Subscriber

    # Publishes tick events at a near-constant 60 FPS.
    class Timer < Base

      TICK_DELAY  = 1.0 / 60.0
      CHECK_DELAY = 0.01

      def initialize(publisher, threads)
        super(publisher)

        @threads = threads
      end

      attr_reader :last_tick_at
      attr_reader :current_tick_at
      attr_reader :delta

      def on_start(event)
        start
      end

      def on_stop(event)
        stop
      end

      def on_exit(event)
        stop
      end

      protected

      def start
        @last_tick_at = @current_tick_at = Time.now
        @delta        = 0.0
        @running      = true

        publish_tick # Publish the first tick

        @threads << Thread.new do
          while @running
            check_tick
            wait
          end
        end
      end

      def stop
        @running = false
      end

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

