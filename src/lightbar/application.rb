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
      @option_controller = OptionController.new(@arguments, @options)
      @message_bus       = DBus::Main.new

      Subscriber::Signal.new(@publisher)
      Subscriber::EventLogger.new(@publisher, @options)
      Subscriber::MessageBus.new(@publisher, @message_bus)
      Subscriber::LightUpdater.new(@publisher, @options)
      Subscriber::Tween.new(@publisher, @options)
      Subscriber::Timer.new(@publisher)
    end

    def_delegators :@publisher, :publish

    def call
      @option_controller.call

      publish(Event::Initialize)

      if @options.daemon

        begin
          bus = case @options.bus
          when :system  then DBus::SystemBus.instance
          when :session then DBus::SessionBus.instance
          end

          service = bus.request_service("org.Lightbar")
          object  = DBusObject.new(@publisher, "/")

          service.export(object)

          @message_bus << bus
        rescue DBus::Error
          @logger.fatal("Unable to create D-Bus session service/object.")
          exit 1
        end

        @message_bus.run

      else

        begin
          bus = case @options.bus
          when :system  then DBus::SystemBus.instance
          when :session then DBus::SessionBus.instance
          end

          service = bus.service("org.Lightbar")
          object  = service.object("/")
          object.default_iface = "org.Lightbar"

          @logger.info("Attempting to run through D-Bus.")

          if @options.from.nil?
            object.tween_to(@options.to, @options.duration)
          else
            object.tween(@options.from, @options.to, @options.duration)
          end
        rescue DBus::Error
          @logger.info("Attempting to run in current process.")

          publish(Event::Tween, @options.from, @options.to, @options.duration)
        end

      end
    end

  end

end

