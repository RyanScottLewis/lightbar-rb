require 'lightbar/subscriber/base'

module Lightbar
  module Subscriber

    # Update the light PWM value on value changes via pi-blaster
    class LightUpdater < Base

      def on_init(event)
        @io = File.open(options.pi_blaster, "w") unless options.dry

        check_pi_blaster
      end

      def on_change(event)
        @io.puts("#{options.pin}=#{event.value}") unless options.dry || @io.nil?
      end

      def on_stop(event)
        @io.close unless @io.nil?
      end

      protected

      def check_pi_blaster
        return if options.dry || File.exists?(options.pi_blaster)

        @logger.fatal("pi-blaster path does not exist: #{options.pi_blaster}")
        exit(1)
      end

    end

  end
end

