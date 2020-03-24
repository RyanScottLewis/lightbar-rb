require 'lightbar/event/base'

module Lightbar
  module Event

    # Emitted when the tween is needs to start.
    class Tween < Base

      def initialize(from, to)
        @from = from
        @to   = to
      end

      attr_reader :from
      attr_reader :to

    end

  end
end

