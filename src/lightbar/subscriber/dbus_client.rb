require 'lightbar/subscriber/base'
require 'lightbar/operation/retrieve_bus'

module Lightbar
  module Subscriber

    class DBusClient < Base

      def initialize(publisher, options, logger)
        super(publisher)

        @options = options
        @logger  = logger
      end

      def on_init(event)
        return if @options.daemon

        retrieve_bus
        retrieve_object
        send_tween
      end

      protected

      def retrieve_bus
        @bus = Operation::RetrieveBus.call(@options.bus)
      end

      def retrieve_object
        service = @bus.service("org.Lightbar")
        @object = service.object("/")

        @object.default_iface = "org.Lightbar"
      end

      def send_tween
        @logger.info("Sending message over D-Bus")

        if @options.from.nil?
          @object.tween_to(@options.to)
        else
          @object.tween(@options.from, @options.to)
        end
      rescue DBus::Error
        @logger.error("Could not send message to D-Bus")
      end

    end

  end
end

