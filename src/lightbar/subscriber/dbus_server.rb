require 'forwardable'

require 'dbus'

require 'lightbar/subscriber/base'
require 'lightbar/operation/retrieve_bus'

module Lightbar
  module Subscriber

    # Starts a D-Bus "server", which emits events according to the D-Bus interface methods called.
    class DBusServer < Base

      class DBusObject < DBus::Object

        extend Forwardable

        def initialize(publisher, path)
          @publisher = publisher

          super(path)
        end

        def_delegators :@publisher, :publish

        dbus_interface "org.Lightbar" do

          dbus_method :tween, "in from:d, in to:d" do |from, to|
            publish(Event::Tween, from, to)
          end

          dbus_method :tween_to, "in to:d" do |to|
            publish(Event::Tween, nil, to)
          end

        end

      end

      def initialize(publisher, options, logger)
        super(publisher)

        @options     = options
        @logger      = logger
        @message_bus = DBus::Main.new
      end

      def on_init(event)
        retrieve_bus
        export_service
        start_run_loop
      end

      def on_exit(event)
        stop_run_loop
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

      def start_run_loop
        @logger.info("Starting D-Bus daemon")

        @message_bus << @bus
        @message_bus.run
      end

      def stop_run_loop
        @message_bus.quit
      end

    end

  end
end

