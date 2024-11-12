# frozen_string_literal: true

# This initializer adds color to the Rails logger output. It's a nice way to
# visually distinguish log levels.
module ColorizedLogger
  COLOR_CODES = {
    debug:   "\e[36m",  # Cyan
    info:    "\e[32m",  # Green
    warn:    "\e[33m",  # Yellow
    error:   "\e[31m",  # Red
    fatal:   "\e[35m",  # Magenta
    unknown: "\e[37m"   # White (or terminal default)
  }.freeze

  RESET = "\e[0m"

  def debug(progname = nil, &block)
    super(colorize(:debug, progname, &block))
  end

  def info(progname = nil, &block)
    super(colorize(:info, progname, &block))
  end

  def warn(progname = nil, &block)
    super(colorize(:warn, progname, &block))
  end

  def error(progname = nil, &block)
    super(colorize(:error, progname, &block))
  end

  def fatal(progname = nil, &block)
    super(colorize(:fatal, progname, &block))
  end

  def unknown(progname = nil, &block)
    super(colorize(:unknown, progname, &block))
  end

  private

  def colorize(level, message, &block)
    "#{COLOR_CODES[level]}#{message || (block && block.call)}#{RESET}"
  end
end

Rails.logger.extend(ColorizedLogger)
