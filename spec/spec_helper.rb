require 'rails/all'
require 'rspec/rails'

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

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
