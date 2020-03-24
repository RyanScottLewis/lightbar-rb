require 'lightbar/operation/base'

module Lightbar
  module Operation
    class RetrieveBus < Base

      def initialize(bus)
        @bus = bus
      end

      def call
        case @bus
        when :system  then DBus::SystemBus.instance
        when :session then DBus::SessionBus.instance
        else;              nil
        end
      end

    end
  end
end

