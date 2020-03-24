require 'lightbar/subscriber/base'
require 'lightbar/operation/retrieve_bus'
require 'lightbar/dbus_object'

module Lightbar
  module Subscriber

    class DBusServer < Base

      def initialize(publisher, options, logger)
        super(publisher)

        @options     = options
        @logger      = logger
        @message_bus = DBus::Main.new
      end

      def on_init(event)
        return unless @options.daemon

        retrieve_bus
        export_service

        @logger.info("Starting D-Bus daemon")

        @message_bus << @bus
        @message_bus.run
      end

      def on_exit(event)
        @message_bus.quit
      end

      protected

      def retrieve_bus
        @bus = Operation::RetrieveBus.call(@options.bus)
      end

      def export_service
        service = @bus.request_service("org.Lightbar")
        object  = DBusObject.new(@publisher, "/")

        service.export(object)
      rescue DBus::Error
        @logger.fatal("Unable to create D-Bus session service/object.")

        exit 1
      end

    end

  end
end

