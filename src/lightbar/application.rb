require 'logger'

require 'lightbar/options'
require 'lightbar/option_controller'
require 'lightbar/publisher'

require 'lightbar/subscriber/signal'
require 'lightbar/subscriber/event_logger'
require 'lightbar/subscriber/message_bus'
require 'lightbar/subscriber/light_updater'
require 'lightbar/subscriber/timer'
require 'lightbar/subscriber/tween'

require 'lightbar/event/initialize'
require 'lightbar/event/start'

require 'lightbar/dbus_object'

module Lightbar

  # Main application.
  class Application

    extend Forwardable

    def self.call(arguments)
      new(arguments).call
    end

    def initialize(arguments)
      @arguments         = arguments.dup
      @options           = Options.new
      @logger            = Logger.new(STDOUT)
      @publisher         = Publisher.new
      @option_controller = OptionController.new(self)
      @message_bus       = DBus::Main.new

      Subscriber::Signal.new(self)
      Subscriber::EventLogger.new(self)
      Subscriber::MessageBus.new(self)
      Subscriber::LightUpdater.new(self)
      Subscriber::Tween.new(self)
      Subscriber::Timer.new(self)
    end

    attr_reader :arguments
    attr_reader :options
    attr_reader :logger
    attr_reader :publisher
    attr_reader :message_bus

    def_delegators :@publisher, :publish

    def call
      @option_controller.call

      publish(Event::Initialize)

      if @options.daemon

        begin
          bus = DBus::SystemBus.instance

          service = bus.request_service("org.Lightbar")
          object  = DBusObject.new(self, "/")

          service.export(object)

          @message_bus << bus
        rescue DBus::Error
          @logger.fatal("Unable to create D-Bus session service/object.")
          exit 1
        end

        @message_bus.run

      else

        dbus = begin
          bus     = DBus::SystemBus.instance
          service = bus.service("org.Lightbar")

          object = service.object("/")
          object.default_iface = "org.Lightbar"

          true
        rescue DBus::Error
          false
        end

        if dbus
          @logger.info("Attempting to run through D-Bus.")

          object.tween(@options.from, @options.to, @options.duration)
        else
          @logger.info("Attempting to run in current process.")

          publish(Event::Tween, @options.from, @options.to, @options.duration)
        end

      end
    end

  end

end

