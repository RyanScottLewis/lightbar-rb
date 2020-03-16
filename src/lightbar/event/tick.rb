require 'lightbar/event/base'

module Lightbar
  module Event

    # Emitted while the timer is running.
    class Tick < Base

      def initialize(timer)
        @timer = timer
      end

      def_delegators :@timer, :last_tick_at, :current_tick_at, :delta

    end

  end
end

