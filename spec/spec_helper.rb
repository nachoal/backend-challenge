ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }


begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.ignore_localhost     = true
  config.hook_into :webmock
end


RSpec.configure do |config|

  config.add_setting(
    :vcr_record_mode,
    default: :new_episodes, # :all, :none
    alias_with: :vcr_record_mode
  )

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
