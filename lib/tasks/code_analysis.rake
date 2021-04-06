namespace :code do
  desc 'Execute code quality'
  task analysis: :environment do
    sh 'bundle exec brakeman . -z -q'
    sh 'bundle exec rubocop .'
    sh 'bundle exec reek app lib public spec tmp'
    sh 'bundle exec rails_best_practices .'
  end
end
