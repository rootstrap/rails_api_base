# frozen_string_literal: true

# Add command aliases
if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

# Add color coding based on Rails environment for safety
if defined?(Rails) && defined?(Pry)
  banner_color = Rails.env.production? ? 41 : 42
  banner = "\e[#{banner_color};97;1m #{Rails.env} \e[0m "

  Pry.config.prompt_name = banner
end
