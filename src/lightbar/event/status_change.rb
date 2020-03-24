require 'lightbar/event/base'

module Lightbar
  module Event

    # Emitted when RetroArch changes status as a result of a `GET_STATUS` UDP request.
    class StatusChange < Base

      def initialize(from, to)
        @from = from
        @to   = to
      end

      attr_reader :from
      attr_reader :to

    end

  end
end

