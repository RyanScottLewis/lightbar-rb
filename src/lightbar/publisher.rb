# Holds a list of subscribers and publishes events to them.
module Lightbar
  class Publisher

    def initialize
      @subscribers = []
    end

    def subscribe(subscriber)
      @subscribers << subscriber
    end

    def unsubscribe(subscriber)
      @subscribers.delete(subscriber)
    end

    def publish(event, *arguments)
      event = event.new(*arguments) if event.is_a?(Class)

      @subscribers.each { |subscriber| subscriber.on(event) }
    end

  end
end

