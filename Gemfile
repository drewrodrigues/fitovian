source 'https://rubygems.org'

ruby '2.4.1'

gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'devise'
gem 'stripe'

# front-end
gem 'turbolinks', '~> 5.0.0'
gem 'ionicons-rails' # icons
gem 'material_icons'
gem 'bootstrap', '~> 4.1.0'
gem 'haml-rails' # templating
gem 'jquery-rails'
gem 'acts_as_list'

# ci
gem 'sentry-raven'
gem 'scout_apm'

# cms
gem 'tinymce-rails'
gem 'tinymce-rails-imageupload', '~> 4.0.0.beta'
gem 'aws-sdk-s3'
gem 'paper_trail'
gem 'faker'

# stack images
gem 'paperclip', '~> 6.0.0'

group :test do
  gem 'minitest', '5.10.0'
  gem 'stripe-ruby-mock', '~> 2.5.2', :require => 'stripe_mock'
  gem 'timecop'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'guard', require: false
  gem 'guard-rspec', require: false
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver', '2.53.4'
  gem 'chromedriver-helper'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'fuubar', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bullet'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
