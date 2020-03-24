module Lightbar
  module Operation
    class Base

      def self.call(*arguments)
        new(*arguments).call
      end

      def call
        raise NoMethodError
      end

    end
  end
end

