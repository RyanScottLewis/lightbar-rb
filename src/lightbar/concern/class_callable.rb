module Lightbar
  module Concern

    module ClassCallable

      def call(*arguments)
        new(*arguments).call
      end

    end

  end
end

