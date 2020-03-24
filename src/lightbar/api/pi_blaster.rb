module Lightbar
  module API
    class PiBlaster

      def initialize
        @io = nil
      end

      def open(path)
        p path
        p File.exists?(path)
        return false unless File.exists?(path)

        @io = File.open(path, "w")

        true
      end

      def close
        return false if @io.nil?

        @io.close
        @io = nil

        true
      end

      def update(pin, value)
        return false if @io.nil?

        @io.puts("#{pin}=#{value}")
        @io.flush

        true
      end

    end
  end
end

