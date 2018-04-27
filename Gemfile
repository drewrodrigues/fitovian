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
gem 'bootstrap', '~> 4.1.0'
gem 'haml-rails' # templating
gem 'jquery-rails'

# error tracking
gem 'sentry-raven'

# lesson cms
gem 'tinymce-rails'
gem 'tinymce-rails-imageupload', '~> 4.0.0.beta'
gem 'aws-sdk-s3'

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
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver', '2.53.4'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
