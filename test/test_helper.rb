ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/spec"

module ActiveSupport
  class TestCase
    # Run tests in parallel disabled by default; enable with PARALLEL_WORKERS.
    # Fixtures disabled: legacy fixtures reference dead tables (admin_users,
    # music_banners) and stale schemas. Smoke/integration tests use factories
    # or direct record creation instead.
    # fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
