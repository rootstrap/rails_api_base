# frozen_string_literal: true

if Rails.env.local?
  # This initializer adds color to the Rails logger output. It's a nice way to
  # visually distinguish log levels.
  module ColorizedLogger
    COLOR_CODES = {
      debug: "\e[36m", # Cyan
      info: "\e[32m",  # Green
      warn: "\e[33m",  # Yellow
      error: "\e[31m",  # Red
      fatal: "\e[35m",  # Magenta
      unknown: "\e[37m" # White (or terminal default)
    }.freeze

    RESET = "\e[0m"

    def debug(progname = nil, &)
      super(colorize(:debug, progname, &))
    end

    def info(progname = nil, &)
      super(colorize(:info, progname, &))
    end

    def warn(progname = nil, &)
      super(colorize(:warn, progname, &))
    end

    def error(progname = nil, &)
      super(colorize(:error, progname, &))
    end

    def fatal(progname = nil, &)
      super(colorize(:fatal, progname, &))
    end

    def unknown(progname = nil, &)
      super(colorize(:unknown, progname, &))
    end

    private

    def colorize(level, message, &block)
      "#{COLOR_CODES[level]}#{message || block&.call}#{RESET}"
    end
  end

  Rails.logger.extend(ColorizedLogger)
end
