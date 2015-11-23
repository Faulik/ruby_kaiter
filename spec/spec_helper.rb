require 'factory_girl'
require 'database_cleaner'
require 'api_matchers'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include FactoryGirl::Syntax::Methods
  config.include APIMatchers::RSpecMatchers

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end
