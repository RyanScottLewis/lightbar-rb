require "socket"
require "timeout"

module Lightbar
  module API
    class Retroarch

      def initialize
        @socket = UDPSocket.open
      end

      def get_status(host, port, timeout=0.5)
        data = Timeout.timeout(timeout) do
          @socket.send("GET_STATUS", 0, host, port)

          @socket.recvfrom(100)
        end

        data[0].split(" ")[1].downcase.to_sym
      rescue Timeout::Error
        nil
      end

    end
  end
end

