# Add color coding based on Rails environment for safety
if defined?(Rails)
  banner = if Rails.env.production?
             "\e[41;97;1m #{Rails.env} \e[0m "
           else
             "\e[42;97;1m #{Rails.env} \e[0m "
           end

  # Build a custom prompt
  IRB.conf[:PROMPT][:CUSTOM] = IRB.conf[:PROMPT][:DEFAULT].merge(
    PROMPT_I: banner + IRB.conf[:PROMPT][:DEFAULT][:PROMPT_I]
  )

  # Use custom prompt by default
  IRB.conf[:PROMPT_MODE] = :CUSTOM
end
