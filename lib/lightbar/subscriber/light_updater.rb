require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    # Update the light PWM value on value changes via pi-blaster
    class LightUpdater < Base

      def on_start(event)
        check_pi_blaster
        open_pi_blaster
      end

      def on_change(event)
        update_value(event.value)
      end

      def on_stop(event)
        close_pi_blaster
      end

      protected

      def open_pi_blaster
        @io = File.open(options.pi_blaster, "w") unless options.dry
      end

      def check_pi_blaster
        return if options.dry || File.exists?(options.pi_blaster)

        @logger.fatal("pi-blaster path does not exist: #{options.pi_blaster}")
        exit(1)
      end

      def close_pi_blaster
        @io.close unless @io.nil?
      end

      def update_value(value)
        return if options.dry || @io.nil?

        @io.puts("#{options.pin}=#{value}")
        @io.flush
      end

    end

  end
end

