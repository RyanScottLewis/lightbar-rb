require 'lightbar/event/base'

module Lightbar
  module Event

    # Emitted when the PWM value needs to be changed
    class Change < Base

      def initialize(value)
        @value = value
      end

      attr_reader :value

    end

  end
end

