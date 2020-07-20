task code_analysis: :environment do
  sh 'bundle exec brakeman . -z -q'
  sh 'bundle exec rubocop .'
  sh 'bundle exec reek .'
  sh 'bundle exec rails_best_practices .'
end
