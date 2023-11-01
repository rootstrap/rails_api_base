# frozen_string_literal: true

# To mark migrations as safe that were created before installing this gem
StrongMigrations.start_after = 20231018000000 #2023/10/18

# Analyze tables automatically (to update planner statistics) after an index is added
StrongMigrations.auto_analyze = true
StrongMigrations.lock_timeout = 10.seconds
StrongMigrations.statement_timeout = 1.hour
