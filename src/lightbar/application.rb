require 'logger'

require 'lightbar/options'
require 'lightbar/option_controller'
require 'lightbar/publisher'

require 'lightbar/subscriber/signal'
require 'lightbar/subscriber/event_logger'
require 'lightbar/subscriber/light_updater'
require 'lightbar/subscriber/timer'
require 'lightbar/subscriber/tween'
require 'lightbar/subscriber/dbus_server'
require 'lightbar/subscriber/dbus_client'
require 'lightbar/subscriber/retroarch_poller'
require 'lightbar/subscriber/retroarch_tweener'
require 'lightbar/subscriber/local_execution'

require 'lightbar/event/initialize'
require 'lightbar/event/start'

module Lightbar

  # Main application.
  class Application

    def self.call(arguments)
      new(arguments).call
    end

    def initialize(arguments)
      @arguments         = arguments.dup
      @options           = Options.new
      @logger            = Logger.new(STDOUT)
      @publisher         = Publisher.new
      @option_controller = OptionController.new(@arguments, @options)

      Subscriber::Signal.new(@publisher)
      Subscriber::EventLogger.new(@publisher, @options)
      Subscriber::LightUpdater.new(@publisher, @options, @logger)
      tween = Subscriber::Tween.new(@publisher, @options)
      Subscriber::Timer.new(@publisher)
      Subscriber::RetroarchPoller.new(@publisher, @options, @logger)
      Subscriber::RetroarchTweener.new(@publisher, tween)
      Subscriber::DBusServer.new(@publisher, @options, @logger)
      Subscriber::DBusClient.new(@publisher, @options, @logger)
      Subscriber::LocalExecution.new(@publisher, @options, @logger)
    end

    def call
      @option_controller.call
      @publisher.publish(Event::Initialize)
    end

  end

end

