require 'lightbar/subscriber/base'
require 'lightbar/api/pi_blaster'

module Lightbar
  module Subscriber

    # Update the light PWM value on value changes via pi-blaster
    class LightUpdater < Base

      def initialize(publisher, options, logger)
        super(publisher)

        @options = options
        @logger  = logger
        @api     = API::PiBlaster.new
      end

      def on_start(event)
        return if @options.dry

        unless @api.open(@options.pi_blaster)
          @logger.fatal("Pi-blaster path does not exist")

          exit 1
        end
      end

      def on_change(event)
        return if @options.dry

        unless @api.update(@options.pin, event.value)
          @logger.warn("Could not update Pi-blaster pin value")
        end
      end

      def on_stop(event)
        return if @options.dry

        unless @api.close
          @logger.warn("Pi-blaster IO is not open")
        end
      end

    end

  end
end

