require 'forwardable'
require 'optparse'

require 'lightbar'

module Lightbar
  class OptionController

    extend Forwardable

    OPTIONS = {
      help:       [ "-h", "--help" ],
      verbose:    [ "-v", "--verbose" ],
      dry:        [ "-D", "--dry-run" ],
      daemon:     [ "--daemon" ],
      pi_blaster: [ "-b", "--pi-blaster VALUE" ],
      pin:        [ "-p", "--pin VALUE" ],
      duration:   [ "-d", "--duration VALUE" ],
      from:       [ "-f", "--from VALUE" ],
      to:         [ "-t", "--to VALUE" ],
      bus:        [ "--bus VALUE" ],
    }

    DESCRIPTIONS = {
      help:       "Display help",
      verbose:    "Display extra information",
      dry:        "Do not perform actions",
      daemon:     "Daemonize the process",
      pi_blaster: "Pi-Blaster device path      (Default: '%s')",
      pin:        "Raspberry Pi BCM pin        (Default: %d)",
      duration:   "Tween duration in seconds   (Default: %.1f)",
      from:       "Value to tween from",
      to:         "Value to tween to           (Default: %.1f)",
      bus:        "D-Bus system or session bus (Default: '%s')",
    }

    HELP = <<~STR
      lightbar v#{Lightbar::VERSION} - Lightbar PWM Tweening Controller

      Usage: lightbar [OPTIONS]

      Options:

          -h, --help              #{DESCRIPTIONS[:help]}
          -v, --verbose           #{DESCRIPTIONS[:verbose]}
          -D, --dry-run           #{DESCRIPTIONS[:dry]}
              --daemon            #{DESCRIPTIONS[:daemon]}
          -b, --pi-blaster VALUE  #{DESCRIPTIONS[:pi_blaster]}
          -p, --pin VALUE         #{DESCRIPTIONS[:pin]}
          -d, --duration VALUE    #{DESCRIPTIONS[:duration]}
          -f, --from VALUE        #{DESCRIPTIONS[:from]}
          -t, --to VALUE          #{DESCRIPTIONS[:to]}
              --bus VALUE         #{DESCRIPTIONS[:bus]}

      Daemonization:

        When daemonized, methods are called over D-Bus.
        The daemon can run on either the system or session bus using the `--bus` option.

        Unfortunately this is written in Ruby and it adds some startup overhead.
        If you want a tween to occur as fast as possible, use the `dbus-send` executable:

          dbus-send --type=method_call --dest=org.Lightbar / org.Lightbar.tween double:0 double:1 double:1
          dbus-send --type=method_call --dest=org.Lightbar / org.Lightbar.tween_to double:1 double:1

        Or use the `lightbar-msg` script:

          lightbar-msg tween 0 0 1
          lightbar-msg tween_to 0 1

      Dependencies:

        * ruby
        * ruby-dbus
        * pi-blaster
        * d-bus

    STR

    def initialize(arguments, options)
      @arguments   = arguments
      @options     = options
      @parser      = OptionParser.new
      @help        = HELP % [@options.pi_blaster, @options.pin, @options.duration, @options.to, @options.bus]

      define_options
    end

    def call
      parse_options
      check_help
    end

    protected

    def define_options
      @parser.on(*OPTIONS[:help],       "") {         @options.help       = true }
      @parser.on(*OPTIONS[:verbose],    "") {         @options.verbose    = true }
      @parser.on(*OPTIONS[:dry],        "") {         @options.dry        = true }
      @parser.on(*OPTIONS[:daemon],     "") {         @options.daemon     = true }
      @parser.on(*OPTIONS[:pi_blaster], "") { |value| @options.pi_blaster = value }
      @parser.on(*OPTIONS[:pin],        "") { |value| @options.pin        = value }
      @parser.on(*OPTIONS[:duration],   "") { |value| @options.duration   = value }
      @parser.on(*OPTIONS[:from],       "") { |value| @options.from       = value }
      @parser.on(*OPTIONS[:to],         "") { |value| @options.to         = value }
      @parser.on(*OPTIONS[:bus],        "") { |value| @options.bus        = value }
    end

    def parse_options
      @parser.parse!(@arguments)
    end

    def check_help
      return unless @options.help

      puts @help
      exit
    end

  end
end

