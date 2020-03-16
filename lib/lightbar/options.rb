module Lightbar

  # The application option structure.
  class Options

    def initialize
      @help       = false
      @verbose    = false
      @dry        = false
      @pi_blaster = "/dev/pi-blaster"
      @pin        = 16
      @duration   = 1.0
      @from       = 0.0
      @to         = 1.0
    end

    attr_reader :help
    attr_reader :verbose
    attr_reader :dry
    attr_reader :pi_blaster
    attr_reader :pin
    attr_reader :duration
    attr_reader :from
    attr_reader :to

    def help=(value)
      @help = !!value
    end

    def dry=(value)
      @dry = !!value
    end

    def verbose=(value)
      @verbose = !!value
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

  end

end

