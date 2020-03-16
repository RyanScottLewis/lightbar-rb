require 'lightbar/event/base'

module Lightbar
  module Event

    # Emitted when the tween is needs to start.
    class Tween < Base


      def initialize(from, to, duration)
        @from     = from
        @to       = to
        @duration = duration
      end

      attr_reader :from
      attr_reader :to
      attr_reader :duration

    end

  end
end

