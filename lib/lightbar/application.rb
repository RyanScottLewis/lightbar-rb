require 'logger'

require 'lightbar/options'
require 'lightbar/option_controller'
require 'lightbar/publisher'
require 'lightbar/subscriber/signal'
require 'lightbar/subscriber/event_logger'
require 'lightbar/subscriber/light_updater'
require 'lightbar/subscriber/timer'
require 'lightbar/subscriber/tween'
require 'lightbar/event/initialize'
require 'lightbar/event/start'
require 'lightbar/event/exit'

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

      Subscriber::Signal.new(self)
      Subscriber::EventLogger.new(self)
      Subscriber::LightUpdater.new(self)
      Subscriber::Timer.new(self)
      Subscriber::Tween.new(self)
    end

    attr_reader :arguments
    attr_reader :options
    attr_reader :logger
    attr_reader :publisher

    def_delegators :@publisher, :publish

    def call
      @option_controller.call
      publish(Event::Initialize)
      publish(Event::Start)
    end

  end

end

