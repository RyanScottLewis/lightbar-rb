require 'lightbar/subscriber/base'
require 'lightbar/event/status_change'
require 'lightbar/api/retroarch'

module Lightbar
  module Subscriber

    # Polls for RetroArch status changes and publishes {Event::StatusChange} events.
    class RetroarchPoller < Base

      def initialize(publisher, options, logger, timeout=0.5)
        super(publisher)

        @options     = options
        @logger      = logger
        @timeout     = timeout.to_f
        @last_status = nil
        @status      = nil
        @api         = API::Retroarch.new
      end

      def on_init(event)
        start_run_loop
      end

      def on_exit(event)
        @running = false
      end

      protected

      def start_run_loop
        @logger.info("Starting RetroArch poller")

        @running = true

        Thread.abort_on_exception = true
        Thread.new do
          while @running
            #@status = @api.get_status(@options.retroarch_host, @options.retroarch_port)
            @status = @api.get_status("127.0.0.1", 55355, @timeout)

            if @last_status != @status
              publish(Event::StatusChange, @last_status, @status)

              @last_status = @status
            end

            sleep @timeout
          end
        end
      end

    end

  end
end

