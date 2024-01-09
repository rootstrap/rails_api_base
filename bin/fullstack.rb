# Add gems
insert_into_file 'Gemfile', after: /gem 'rails'.*\n\n/ do <<~EOF
  gem 'cssbundling-rails', '~> 1.3'
  gem 'stimulus-rails', '~> 1.3'
  gem 'turbo-rails', '2.0.0.pre.beta.2'
  gem 'view_component', '~> 3.7.0'
  EOF
end

insert_into_file 'Gemfile', after: "group :development do\n" do <<~EOF
  gem 'lookbook', '~> 2.1'
  EOF
end

Bundler.with_unbundled_env { run 'bundle install' }

# Add npm packages
run 'yarn add @hotwired/stimulus@^3.2.2'
run 'yarn add @hotwired/turbo-rails@^8.0.0-beta.2'
run 'yarn add esbuild-rails@^1.0.7'

# Run generator
run './bin/rails css:install:tailwind'

# Update application layout
gsub_file 'app/views/layouts/application.html.erb', "    <%= stylesheet_link_tag \"application\" %>\n", ''
insert_into_file 'app/views/layouts/application.html.erb', before: /\s*<\/head>/ do <<~EOF
  \n    <%= javascript_include_tag \"application\", \"data-turbo-track\": \"reload\", defer: true %>
  EOF
end

# Application JS entrypoint
add_file 'app/javascript/application.js' do <<~EOF
  // Entry point for the build script in your package.json
  import "@hotwired/turbo-rails"
  import "./controllers"
  EOF
end

# StimulusJS
add_file 'app/javascript/controllers/application.js' do <<~EOF
  import { Application } from "@hotwired/stimulus"

  const application = Application.start()

  // Configure Stimulus development experience
  application.debug = false
  window.Stimulus   = application

  export { application }
  EOF
end

add_file 'app/javascript/controllers/index.js' do <<~EOF
  import { application } from "./application"

  // Import app/components/index.js
  import "../../components"
  EOF
end

insert_into_file 'esbuild.config.mjs', after: "import * as esbuild from 'esbuild'\n" do <<-EOF
import rails from 'esbuild-rails'
EOF
end

insert_into_file 'esbuild.config.mjs', after: "  outdir: 'app/assets/builds',\n" do <<-EOF
  plugins: [rails()],
EOF
end

# ViewComponent config
add_file 'app/components/index.js' do <<~EOF
  import { application } from "../javascript/controllers/application"
  import controllers from "./**/*_controller.js"

  controllers.forEach((controller) => {
    application.register(controller.name, controller.module.default)
  })
  EOF
end

insert_into_file 'config/environments/development.rb', before: /^end$/ do <<~EOF

    # ViewComponent Previews
    config.view_component.preview_paths << "\#{Rails.root}/spec/components/previews"
  EOF
end

insert_into_file 'config/routes.rb', before: /^end$/ do <<~EOF
    mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?
  EOF
end

gsub_file 'tailwind.config.js', "    './app/javascript/**/*.js'\n" do <<-EOF
    './app/javascript/**/*.js',
    './app/components/**/*.{erb,haml,html,slim,css,js}'
EOF
end

# Fix Rubocop offenses
run "bundle exec rubocop -A ."
