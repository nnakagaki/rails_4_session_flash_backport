require 'active_support/core_ext/hash/except'
require 'action_dispatch'
require 'action_dispatch/middleware/flash'

# Backport discarding before session persist to rails 4
module ActionDispatch
  class Flash
    class FlashHash
      def self.from_session_value(value) #:nodoc:
        flash = case value
                when FlashHash # Rails 3.1, 3.2
                  new(value.instance_variable_get(:@flashes), value.instance_variable_get(:@used))
                when Hash # Rails 4.0
                  new(value['flashes'], value['discard'])
                else
                  new
                end

        flash.tap(&:sweep)
      end

      def to_session_value #:nodoc:
        return nil if empty?
        {'discard' => @discard.to_a, 'flashes' => @flashes}
      end
    end
  end
end

