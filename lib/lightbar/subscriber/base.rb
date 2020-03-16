require 'forwardable'

module Lightbar
  module Subscriber

    # Subscriber abstract class which receives events from a publisher it's subscribed to.
    class Base

      extend Forwardable

      def initialize(application)
        @application = application

        publisher.subscribe(self)
      end

      def_delegators :@application, :options, :logger, :publisher
      def_delegators :publisher, :publish

      def on(event)
        case event
        when Event::Initialize then on_init(event)
        when Event::Exit       then on_exit(event)
        when Event::Tick       then on_tick(event)
        when Event::Stop       then on_stop(event)
        when Event::Change     then on_change(event)
        end
      end

      def on_init(event)
      end

      def on_exit(event)
      end

      def on_tick(event)
      end

      def on_stop(event)
      end

      def on_change(event)
      end

      protected

      def unsubscribe
        publisher.unsubscribe(self)
      end

    end

  end
end

