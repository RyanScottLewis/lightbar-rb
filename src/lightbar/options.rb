module Lightbar

  # The application option structure.
  class Options

    BUSSES = %i[system session]
    CURVES = %i[linear quadratic cubic sine]

    def initialize
      @help       = false
      @verbose    = false
      @dry        = false
      @daemon     = false
      @pi_blaster = "/dev/pi-blaster"
      @pin        = 16
      @duration   = 1.0
      @from       = nil
      @to         = 1.0
      @bus        = :system
      @curve      = :linear
    end

    attr_reader :help
    attr_reader :verbose
    attr_reader :dry
    attr_reader :daemon
    attr_reader :pi_blaster
    attr_reader :pin
    attr_reader :duration
    attr_reader :from
    attr_reader :to
    attr_reader :bus
    attr_reader :curve

    # TODO: This should all be somewhere else really

    def help=(value)
      @help = !!value
    end

    def verbose=(value)
      @verbose = !!value
    end

    def dry=(value)
      @dry = !!value
    end

    def daemon=(value)
      @daemon = !!value
    end

    def pi_blaster=(value)
      @pi_blaster = value.to_s
    end

    def pin=(value)
      @pin = value.to_i
    end

    def duration=(value)
      @duration = value.to_f
    end

    def from=(value)
      @from = value.to_f
    end

    def to=(value)
      @to = value.to_f
    end

    def bus=(value)
      value = value.to_sym
      return unless BUSSES.include?(value)

      @bus = value
    end

    def curve=(value)
      value = value.to_sym
      return unless CURVES.include?(value)

      @curve = value
    end

  end

end

