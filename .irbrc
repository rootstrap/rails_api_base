# frozen_string_literal: true

# Add color coding based on Rails environment for safety
if defined?(Rails)
  banner_color = Rails.env.production? ? 41 : 42
  banner = "\e[#{banner_color};97;1m #{Rails.env} \e[0m "

  # Build a custom prompt
  IRB.conf[:PROMPT][:CUSTOM] = IRB.conf[:PROMPT][:DEFAULT].merge(
    PROMPT_I: banner + IRB.conf[:PROMPT][:DEFAULT][:PROMPT_I]
  )

  # Use custom prompt by default
  IRB.conf[:PROMPT_MODE] = :CUSTOM
end
