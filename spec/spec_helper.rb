ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails' do
  # ignore devise controllers
  add_filter "app/controllers/users/"
end
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'factory_bot_rails'
require 'devise'
require 'database_cleaner'
require 'helpers/flow_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.example_status_persistence_file_path = 'examples.txt'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :feature

  config.before(:suite) do
    # DB Cleaner
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    # Capybara
    Capybara.default_max_wait_time = 5

    # StripeMock
    StripeMock.start
    StripeMock.create_test_helper.create_plan(:id => 'starter', :amount => 1999)
  end

  config.after(:suite) do
    StripeMock.stop
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end