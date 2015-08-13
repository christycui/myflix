source 'https://rubygems.org'
ruby '2.1.6'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt', '~> 3.1.5'
gem 'fabrication', '~> 2.12.2'
gem 'faker', '~> 1.4.3'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener', '~> 1.4.1'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.2.1'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email', github: 'dockyard/capybara-email'
end

group :production do
  gem 'rails_12factor'
end

