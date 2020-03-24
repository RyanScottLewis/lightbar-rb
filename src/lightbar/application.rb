require 'logger'

require 'lightbar/options'
require 'lightbar/publisher'

require 'lightbar/concern/class_callable'

require 'lightbar/subscriber/signaller'
require 'lightbar/subscriber/option_parser'
require 'lightbar/subscriber/event_logger'
require 'lightbar/subscriber/timer'
require 'lightbar/subscriber/tweener'
require 'lightbar/subscriber/pi_blaster_updater'
require 'lightbar/subscriber/retroarch_poller'
require 'lightbar/subscriber/retroarch_tweener'
require 'lightbar/subscriber/dbus_server'

require 'lightbar/event/initialize'

module Lightbar

  # Main application.
  class Application

    extend Concern::ClassCallable

    def initialize(arguments)
      @arguments = arguments.dup
      @options   = Options.new
      @logger    = Logger.new(STDOUT)
      @publisher = Publisher.new

      Subscriber::Signaller.new(@publisher)
      Subscriber::OptionParser.new(@publisher, @options, @arguments, @logger)
      Subscriber::EventLogger.new(@publisher, @options, @logger)
      Subscriber::Timer.new(@publisher)
      tweener = Subscriber::Tweener.new(@publisher, @options)
      Subscriber::PiBlasterUpdater.new(@publisher, @options, @logger)
      Subscriber::RetroarchPoller.new(@publisher, @options, @logger)
      Subscriber::RetroarchTweener.new(@publisher, tweener)
      Subscriber::DBusServer.new(@publisher, @options, @logger)
    end

    def call
      @publisher.publish(Event::Initialize)
    end

  end

end

