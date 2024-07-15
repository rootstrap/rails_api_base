# Add gems
insert_into_file 'Gemfile', after: "# Gems\n" do <<-EOF
gem 'cssbundling-rails', '~> 1.3'
gem 'stimulus-rails', '~> 1.3'
gem 'turbo-rails', '2.0.0.pre.beta.2'
gem 'view_component', '~> 3.7'
EOF
end

insert_into_file 'Gemfile', after: "group :development do\n" do <<-EOF
  gem 'lookbook', '~> 2.1'
EOF
end

Bundler.with_unbundled_env { run 'bundle install' }

# Add npm packages
run 'yarn add @hotwired/stimulus@^3.2.2'
run 'yarn add @hotwired/turbo-rails@^8.0.0-beta.2'
run 'yarn add esbuild-rails@^1.0.7'

# Run CSS generator
rails_command 'css:install:tailwind'

# Update application layout
gsub_file 'app/views/layouts/application.html.erb', "    <%= stylesheet_link_tag \"application\" %>\n", ''
insert_into_file 'app/views/layouts/application.html.erb', before: /^  <\/head>$/ do <<-EOF
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
EOF
end

# Application JS entrypoint
add_file 'app/javascript/application.js' do <<-EOF
// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
EOF
end

# Stimulus
add_file 'app/javascript/controllers/application.js' do <<-EOF
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
EOF
end

add_file 'app/javascript/controllers/index.js' do <<-EOF
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
add_file 'app/components/index.js' do <<-EOF
import { application } from "../javascript/controllers/application"
import controllers from "./**/*_controller.js"

controllers.forEach((controller) => {
  application.register(controller.name, controller.module.default)
})
EOF
end

insert_into_file 'config/environments/development.rb', before: /^end$/ do <<-EOF

  # ViewComponent Previews
  config.view_component.preview_paths << "\#{Rails.root}/spec/components/previews"
EOF
end

insert_into_file 'config/routes.rb', before: /^end$/ do <<-EOF
    mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?
  EOF
end

insert_into_file 'tailwind.config.js', before: "    './app/javascript/**/*.js'" do <<-EOF
    './app/components/**/*.{erb,haml,html,slim,css,js}',
EOF
end

insert_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do <<-EOF
require 'view_component/test_helpers'
require 'view_component/system_test_helpers'
EOF
end

insert_into_file 'spec/rails_helper.rb', after: "  config.include ActiveJob::TestHelper\n" do <<-EOF
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::DSL, type: :component
  config.include Capybara::RSpecMatchers, type: :component
EOF
end

# Add example component

if yes?("Do you want to add an example component? [y/n]")

add_file 'app/components/example/component.rb' do <<-EOF
module Example
  class Component < ViewComponent::Base
  end
end
EOF
end

add_file 'app/components/example/component.html.erb' do <<-EOF
<div data-controller="example--component">
  <span class="after:content-['CSS_works!']" data-example--component-target="hello">HTML works!</span>
</div>
EOF
end

add_file 'app/components/example/component_controller.js' do <<-EOF
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['hello'];

  connect() {
    const cssValue = window.getComputedStyle(this.helloTarget, ':after').getPropertyValue('content');
    this.helloTarget.classList = '';
    this.helloTarget.innerText += ` ${cssValue} JS works!`;
  }
}
EOF
end

add_file 'spec/components/example/component_spec.rb' do <<-EOF
require "rails_helper"

RSpec.describe Example::Component, type: :component do
  it "renders component", :js do
    with_rendered_component_path(render_inline(described_class.new), layout: "application") do |path|
      visit(path)

      expect(page).to have_text "HTML works!"
      expect(page).to have_text "CSS works!"
      expect(page).to have_text "JS works!"
    end
  end
end
EOF
end

add_file 'spec/components/previews/example/component_preview.rb' do <<-EOF
class Example::ComponentPreview < Lookbook::Preview
  def standard
    render Example::Component.new
  end
end
EOF
end

end

# Fix Rubocop offenses
run "bundle exec rubocop -A ."

# Precompile assets
rails_command "assets:precompile"
run "yarn build"

# Run tests
run "bundle exec rspec spec/components/example/component_spec.rb"
