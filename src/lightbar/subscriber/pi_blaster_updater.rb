require 'lightbar/subscriber/base'
require 'lightbar/api/pi_blaster'

module Lightbar
  module Subscriber

    # Update the light PWM value on {Event::Change} events via pi-blaster.
    class PiBlasterUpdater < Base

      def initialize(publisher, options, logger)
        super(publisher)

        @options = options
        @logger  = logger
        @api     = API::PiBlaster.new
      end

      def on_start(event)
        return if @options.dry

        @logger.info("Opening Pi-blaster IO")
        success = @api.open(@options.pi_blaster)

        @logger.warn("Pi-blaster IO could not be opened") unless success
      end

      def on_change(event)
        return if @options.dry
        success = @api.update(@options.pin, event.value)

        @logger.warn("Pi-blaster pin value could not be updated") unless success
      end

      def on_stop(event)
        return if @options.dry

        @logger.info("Closing Pi-blaster IO")
        success = @api.close

        @logger.warn("Pi-blaster IO could not be closed") unless success
      end

    end

  end
end

